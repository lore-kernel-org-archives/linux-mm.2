Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6252CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 00:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152246B0008; Wed, 27 Aug 2025 20:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129FA6B0022; Wed, 27 Aug 2025 20:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33BF6B0024; Wed, 27 Aug 2025 20:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBFC46B0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:38:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B01F13A2FD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:38:41 +0000 (UTC)
X-FDA: 83824305642.19.2667585
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20701180009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:38:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T0dSBEkq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=H+6t8iWZ;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756341518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMR9kM70sSX4wVCt9NHfjM3tTx9sCe9KVzMiYP8miLM=;
	b=1AGcL+d5/AiBXpA+WMZb0Un3kCRWGxXfAAaUDgnvZgpERqAMn4N5arDPKD5pjoW8ZW06/J
	DA2vwHqPpzU7I/vXCpj7UjWBLzjku3ZTJx5hPhMByaM6Rt4rucFBIsqLFTeTQfhd3hsGkk
	nbojoDno8vjBBOCa0TT58N/xs0lKtYc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T0dSBEkq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=H+6t8iWZ;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756341518; a=rsa-sha256;
	cv=pass;
	b=UorGQi4WeKgC/ss75xjaFaxPhTKqLtQ5ses6ZerSIJMJX9KW5yZHFnyCbt1wvH/cOKDmY5
	jHnUPPs7ZzyPprlT4WZSCvjFc4oMmaV9WacregBeAJ6FleJpNFc87fPRt91NM0wogs8Mgj
	K7tbLIZ/R6Aq4B71g//OP0PKWWzlfvQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHBs9023306;
	Thu, 28 Aug 2025 00:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fMR9kM70sSX4wVCt9N
	HfjM3tTx9sCe9KVzMiYP8miLM=; b=T0dSBEkqAp9x/+7LOBhOj/Swx+s2nWU+Kj
	Fh0BJdW+z3zV5mu4u4HriLdEKgdaTDL6J7sMUeDkpamOBkCj97hAXfEa+RwDwBvp
	xKPSJO4KACd0hTICqKP916Q0Sxp+baOluX+1I2tvCdNWzKRZOSEp+vhBlx7jPKIm
	75JqeBc0/l6+KzkSIGaMLfpi768fmKt2S99pv97syI/8TcPy2BbS5ThXaZdpmx+m
	VhMBmtg88U4IVknUhmmQzIsQ9dUEmHdOYbLo8HUHIeGxEdY5Akt1k4xaO7f/3+oT
	tCPAoX2IMbnd5vFZhpCdq5aADtVPgO/Imml48muovPAHz/K2L8jQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s7gsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:38:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RMVEpd014625;
	Thu, 28 Aug 2025 00:38:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43b8gmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 00:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpRz1pf5ylZQ7wbHrMt081lO+GuCjbXJmcnM8i5OJQW+buFa4q3VvscKU4xezOZpFL8977r60DbF+YLVsxt2UgCwDLK9b+D/nEUu3pNoavuIr+8OXngqc4FAFyQw+Kjt9Y+X2DDeo81XKH7jMVDNhSmQVUX7xgzx0gf1Taw4vfTd/Nqup9K90eiqq8VpC7+WWJ7n+r+cS96/uZEseMVUaNiqT2WY0u6t8ypBT4X2d9qwL0Dy8oZcyDNGotGXsQii2CjE8rzFu8sFXEGfcnoaOj496C4jLYxYEF4NehOSwxX/4+e2gr8hUmIoBnKQOGMUv0OQ9y9xBsLPclugndrYKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMR9kM70sSX4wVCt9NHfjM3tTx9sCe9KVzMiYP8miLM=;
 b=Ug2/x8ByGHLJY1OhY6MI6iR9XpQ5Y0T5FhDbmTNuHiUOQt8WmJpkgu8WbdiyU263CwSgR4rVmxv4D3xxiq4aI8zDPSm9NMuKzzCkg1CDEZrXQzu2T+bx6NpxTLsXDgd/ITR7o+ug/PCHMCREfnhrjjEX6Lbew4jHhjRjVJ7GCWQctGiCWP1HM1qS8gak+OTtOVSFTeHzQF8rbnjNNjNd41G+8hzDYnZ4mlzVYaoE+5vZOVSHSX7XGq5KGvPVjzSCE0bNBiHEoBB1fuk4GEa015p3HIEc0X09l/INhlv5VWyukFruqm35o+F42Q50wmea6aYekQzAOoIVd0rMSY43wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMR9kM70sSX4wVCt9NHfjM3tTx9sCe9KVzMiYP8miLM=;
 b=H+6t8iWZnmPnoNry59X8aBrz1qWm4AO+n4uejo9OIthT2POcB9q+zPZrYVQGu/OT+SK5cGtl9Z1J2kelAEaLsxf08M7Y40veY5WR+ukTp0KjG+UaRmNH7gP/CZo0X7KIqJ0XpksaPYPe1WIlx6nVOiIdIcZHW8BxdX4Lk/zhsn0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO6PR10MB5649.namprd10.prod.outlook.com (2603:10b6:303:14c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 00:38:28 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:38:28 +0000
Date: Wed, 27 Aug 2025 20:38:25 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
        feng.han@honor.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        liulu.liu@honor.com, lorenzo.stoakes@oracle.com, mhocko@suse.com,
        rientjes@google.com, shakeel.butt@linux.dev, tglx@linutronix.de
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <ie3rhh3pkr5izrlpryytwrfuhhrxjrhk3dgvlg6zg3ruzwdcdw@zfh25zdokcqq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org, 
	feng.han@honor.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	liulu.liu@honor.com, lorenzo.stoakes@oracle.com, mhocko@suse.com, rientjes@google.com, 
	shakeel.butt@linux.dev, tglx@linutronix.de
References: <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf>
 <20250827095535.13979-1-zhongjinji@honor.com>
 <CAJuCfpFf7SKEi36+EAGwVbBT8A8LubrbUg6=F3QYDSa62PpioA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpFf7SKEi36+EAGwVbBT8A8LubrbUg6=F3QYDSa62PpioA@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0080.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO6PR10MB5649:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b8cf5d1-3ea7-4d29-cc7a-08dde5cb34d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yeeJBifrYNAsewsP6vvj1Filt5Bm35pdQ4zoVRjsI2IReD33fA7/FoHOpH43?=
 =?us-ascii?Q?+N3xWwDRvpelJw4FJmXu6k9uG/qSCucUS2cdY8MTXFfvhiUGxsOjO59PaFVw?=
 =?us-ascii?Q?K2ZbpmVAvE0dNabhI/c1607SJxUaHETKDIwgvkbqTyfM6568HR3wtMLBrWVl?=
 =?us-ascii?Q?ShK4/AJKELSwJkQt0VKYdHFT7Nnqy9q19zxxZqjLo/4iZXwR8yRV4ijIPjrW?=
 =?us-ascii?Q?xutvkENxjCYW+wlvOybxJkvp5NCguiypuKy5/MqvCpSjoC9a/tS+DfXMGd6i?=
 =?us-ascii?Q?m+PTxfKbfHIVmBwzFdlHoASHXP7ZnuMV80fbNkwG2aZWnk155gQI56jeAhS9?=
 =?us-ascii?Q?vJqFTra4Yy73yBbKlReArl2f1IjaXXHb4d8QUBJqGoeZ/4b4SegR6cUwma3/?=
 =?us-ascii?Q?0kvvuBzZoavRz7XaMliiBEt/VL5/40HnaW13NRh6uxWKZJsylS0uPj5XC/Yv?=
 =?us-ascii?Q?r0CHAp3jLSV8WZIQMky0LelXSwqfqrIKPeeRI5YjXmeKVG2Lc8ydj5NHWF9O?=
 =?us-ascii?Q?Hy5SJlZMkebZRQMQS/htKp+KK70948+lVtBw/ErP9CYJYhMLu9E2DRigzrUH?=
 =?us-ascii?Q?wvdcBfM6Rf+3F08dCRVSA+ENDxFjjS9TZx348R6JLyGxHBCqa7CS6fviRzv1?=
 =?us-ascii?Q?kZqotXLnjpCnzMGvcQ0Kpcx/ZaSs8LoVoLvMO5m4ej0Wvv/fvtNJEsWu4Mkm?=
 =?us-ascii?Q?+ajrKw/fAbp1DWKCcXb8p8CMmDrOJngmWXgsrkCNNfWgzX+R2XoKTice/OhR?=
 =?us-ascii?Q?B2TrEYV6vbkKgy63r6imJFMG3NGJSuaENv0MFkDlkMToxXGavSp6j6/AVeW/?=
 =?us-ascii?Q?Zzt/V8w11QhJnsGLt8lYziAqTs8vI4KVs9hhoCrHbTfs+K5+cWuqew/O3u0d?=
 =?us-ascii?Q?RYxKA45NW0LnGLD3Ub611mz1uGKkUHWEAnWJ9+yLYypMgHU+9u3tHcXzupjQ?=
 =?us-ascii?Q?QdJakP9j5RyftGjpnfnFz/QzPk/OqM9DodNEwZBQdjEgbc28XePY7PPEf5yd?=
 =?us-ascii?Q?qcCAQDSeCGH7te61TTM0RHadVaczA91fTrHaYEhtIS2Mu3IetH1Ad6k3UCLm?=
 =?us-ascii?Q?jXsnTunF3fFGsQ2gKjgxnTHuvMfCmU2W7Riubr3HhA8QjYo8+Fr4Emug5mQD?=
 =?us-ascii?Q?D40VjHPjhlSY29+X3DwnmpaGLxYd1GyxiDV9Ema4P4D1oOnkAvWQU6dy2I/7?=
 =?us-ascii?Q?V4X2p9coFvo8ftxntLk65zpDP8B5y4VqyOLhvzdQTX1u8knNH/yteMNn0DPZ?=
 =?us-ascii?Q?jJSYyUrgAvasp3O97QP5DI8qszNpfUidVk4nkMLxLhSRCdYWRsJcdFCqXLFD?=
 =?us-ascii?Q?8h6SvYl4AtWxclesNkgfJMebA6VaWUEbsmNcKaybQ9z6e2NMoLljsK8xcDdx?=
 =?us-ascii?Q?sNjzwEes2pem+0do2OCIuM20khyWnnXk8l+PPDAYhfppMvNapmDtyNAxJY5x?=
 =?us-ascii?Q?FYQ6CFtNP5E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8v68QLSWEqqVfQjsDo37xo4ZvNGdAMN8M+WEj0i0nVCIa//XQrlifV155qKN?=
 =?us-ascii?Q?b9rwW9QT9O8oAVTGKWmVpWid9RcZydeoS5xDa0MhZkcW9q2+D8Qb9C97ry3A?=
 =?us-ascii?Q?gzDwjmCGzYVo80xwyasoUgD9M94wDETLZya219FbiXcqdc9X/XsySwWwrAKj?=
 =?us-ascii?Q?CGAOwSPgShoeSBhXr3sA7eNOfu8mYybUKXdk74FvzAwQR8dFwRMMOnhV9VGa?=
 =?us-ascii?Q?YkUSxP8K40LO1YYYIL10F1hbpjgIlmIg4tmjidLvrhH+Gl+6LiHbiIFMCNHP?=
 =?us-ascii?Q?qITQ0FOkHBnR4p+pgPor84tsDO9k13WSWLVCISIVxiNGIbv1HaT7RDQvf/eW?=
 =?us-ascii?Q?AWLienxWsVeacfZqJH/JqUqYjyFVTp5b+o4McHmlmUR6PGHhQa7qpx1oDsrn?=
 =?us-ascii?Q?8RFKi3Z8RKEbgINMd4t8qqjm2JhgY0pmYgAE4ZMVK2W+1ZOnBp5ZYx6rjnAO?=
 =?us-ascii?Q?a3Mo7SMuB08D8Nc2hwfvx/+rsN4/qEVMorclPeEOsJLNjzC+wu/l38Do/pmX?=
 =?us-ascii?Q?vKs32b5/xY6eAA+Ol7TdF6UuNZS9LsFt2AB0NjOZIdHYeB6Zze/Zx6U64MW6?=
 =?us-ascii?Q?ehmXQ35Iq5om4kfESfvzDgW+sbo4pZSWBv0GbIePkXyK2EX9k9LowjRuIHbu?=
 =?us-ascii?Q?pdfBPbz1cCKL5IE+lL/z/NczH2yBkHmJtno63Tq3q2SuT+SkTxh2G9hcsdLY?=
 =?us-ascii?Q?g7NU5/xrNJILzi/NY+6hkJ8jzBznd9/w+hmIhNYzPkaPXMo/pqtTGeDkj96l?=
 =?us-ascii?Q?JQ1/LAf3rhtg3z2zHr55hYuLZ26gTa9dUMFksjB5ovYU39eyVhH+xvR3R+gi?=
 =?us-ascii?Q?YbCxsWAKBWtJ2bBPaFNWlzDAaB/O5aeyiebIEFqVobe+WliEAvw29o+eIvOy?=
 =?us-ascii?Q?TDOxNs+khyHpAxIma7tM3XT5iZmHfdj4HiqukSZwHP6DGbCBTL1dhDcGqowp?=
 =?us-ascii?Q?i5w8eKzXeBeukplzLYWpML6tO+A2Zyagqlxi2P9JT5IfNOIFtTGMZwAqkZaa?=
 =?us-ascii?Q?UaA1HvH0EBUhiyn0YO6eLFS7rfWwI3QxHFXLWeZqe4HJviA/hy/GuDhOJYvK?=
 =?us-ascii?Q?zWmAbuWHVqBaw7dr3XvQAILAKGyCijFZwVepZ/TephhA54R1BCkQKX8eS/aE?=
 =?us-ascii?Q?WRxOoHvz9oODaVNHlWj2Bnl4EQiBOWQ6rCtZ33NBsMi3dMmGOy+bvYctk/Pr?=
 =?us-ascii?Q?k/ZzSovqnZzPaPVVqS38PhhXbo/R9JUqR70O0d2xmsZ0jXbj5F4q1Kj58+LM?=
 =?us-ascii?Q?vzHOPBK+hucXlLqp5VkR8sNu70c6SZ90YkdXJNOpiqLpupJXdOOjef7wStCI?=
 =?us-ascii?Q?8AEcfXG9uuKz7sQvtkkc6fvQ01BSuyXb0+jugsJvqaHCJzMet0FZaeJVSGat?=
 =?us-ascii?Q?r10O7kKZL7Nf0lNXpwyVue+CqzsWo1Ewt9HEOHqFCRRr1xWMQh50JEYBGGHd?=
 =?us-ascii?Q?x8gBRC0rQR2GRoMWads4yL1LLLDRIWsI3YqmkV5vR3UPOx4qGC/5v6RRwmbD?=
 =?us-ascii?Q?zU33xwMg7Yfrfx2DZbp4A+G7RZtEkHHTpG5scSpl4HuoXVML/0OZYzp+X+Bh?=
 =?us-ascii?Q?vRWWWbO4jRAS/F+lIU3UovAjr3wV7Zr/hberBENpOe8KQOWLFRpdGpZIO8G7?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R9v5xRUWgmyF5TPxNKBmwJlXufI1sflxj5zLu/i05ex/SDnpIimfas92D9E1tXgyFVMqxI376GqH1tBtVcQAiSnGDc0T61/3tOBmXt/WBudg4EnT2hQuOLZ6xeLPhj/BhyF7KoNx4C8U2nDz+M+NhoYtBTGuwklgtAIHvsjHIE3XslWjpIZKQNUNooby0iJ0kWAJJfK6dn5ARbLWrCQLdJjjgleiBKTefPdUepZUiXS6LK9jGve9G2oRdezKMy6aBfUJEBEhwIDUHyL0tPJ03n7TmIy4wZ6P+XeVqcF1ZcWaQ9JFy4nlQLjmrmWPNDsX62IQAGWQ2ZIZpSlFQJUkIvDoSGqDvHuQTHzO9R5B6K7h6rHr3is2oNb+HwiOODIDb8h4WOfEoXoyqmLaeky8GACjuiKobxDWf0nHlUpVEhLLguLnLmRphIIww4w34+wSDHE9ZERywde0WIqzsw9BdIZPTb6fUQQ+FLLRpyU2oXDq4GRZz0EsAoDsyke5qGtR877+EA3V2tDqIeB5utkmY278nghGnDHIhdjqZzHxSqjYfIwnnBWeSH7kHTdJACd1JxeUXa5OjyN925D6u4PSLfrvQukBgvlRn7uBuc6KGbM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b8cf5d1-3ea7-4d29-cc7a-08dde5cb34d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:38:28.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NLRsMpHggUUp9nMpnckhoDtSMjjnqjeUHILh/ViitOZlCgAlmLvCmTtJLmVtkzNkPEeF/0ki67Hw4UrC32TJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280003
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68afa508 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=GV04K3bB3viaPYwMHJkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-GUID: 3N5yCuSOwtAcumDld_AnMn4oq47LazTV
X-Proofpoint-ORIG-GUID: 3N5yCuSOwtAcumDld_AnMn4oq47LazTV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfXzeNJ4A1YMild
 PAYDbr+eidyc5GRuykUatp0rSvUJyochlPnv9O7K6B1vSd7HpYgPaTtlxdoMveLBfcXmrmyzdv/
 BT396Ggy9LMiFkbNvYVJFER/ooFCA2y2NYzqvTmtt555gaBbmqQFdl0kUqS6I19VSpsMMvqj1Hq
 QryGjJGOMA78W/s9hQlLRUtQG58bFQsc52iF9Qn/44mLvop4M+DXMJRKf5HVUC/4zoHA/tUmIIl
 e8hih94Hn0kpsHgGfeU3yAXMggL9nk3H264WebjWlzrpeEd6QcCwF4kfIraflaMxye7Hvc+jZBv
 RarAZxCJKcp9JKe/pddqlvF6TMYlR/Q9dVz2Y7okX2POZFtMjo0F1GBCCTf+0KoV4/OgQypw0Df
 3pT5hUpWbtIwjjjhSoiBoLV9O4Mk4w==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20701180009
X-Stat-Signature: u4jcx7zoq3mfm3tjzf4by657m6q6d3fy
X-Rspam-User: 
X-HE-Tag: 1756341517-409954
X-HE-Meta: U2FsdGVkX1+Arrw3wqTqNLRBk5MeSVacmgJ3lOS3GFE6iIQ8F4oYPx7uNAZdDU2qeAiQW12ujav0I0wkFoZ0ipAtHWBlE8Vww91LFtUAbMJtj0gCstjO2vtJ2P5+X0ECR2Zwq+NBrY3uZfCQxDgrVxsYVsjpAoeTe9nSBLr/Qq2mXf76g4Jz53MXl3Bgc6ZYMzLTm92pH9CwaJq0uVxLC5EtPGWIFHjpAl+fXojhwfTBhuGPjBxnBcVGMbqMmcQVhm1aqqU2Rt1VyQU3Zo3GVmfTjSMpju5fC8TaNt09cqUXK0e7zJ+wQPWnWYH1DUXvE8CpUIcEerwWFEKGWObs22HzHuOoftQ69aqpY854PtZFtukRa/uEqx8q2mCVkuQqabFPbadvsNObYQqjuAoVDv8k1YkfVXoMTMqBvf2YqUxL0Ssmr3F5QZnavb1OWmfGiEvB3P7DrHM9R8HUEqEjHkUHFsvH+9QFmzRn9WvPfqOuq5Gnz3OpFHppv8zJ7NCBOdQdWpKQRxv9WUrxhA6OBRuyvaSx08CvgwAHbvzUEMsFW/iLFDQUHysWXY7TahqRZd1kDaprqt+ratWPB/6WNuOWGmV0id2DrkhG203zgPZPwgR3FAdO/BeKNunzC/qpIa47DZ6Yr/H2I+W7RfaOwyXLjSo+bssXA4oNPx59cpVJPP1T951wFQYKsYPCn/O1sfz+Q7jtYS+MnRMF7oQjWGqq9Mth277NG0koIZnLT4Qyfc+PAzYhV8c7taRVvLcjoPhbgJhhonuhT6tCvwEr11C8n0S9F3XVTBZyTaFTg+B6S6fZrSg6cHp1t56OvC9GOWjFTsbO67cqJTl21U/uR5RaWsrRIRZzWyXS5HuUa64l6s8ZpKEY2xdnRnMKNU5kOHpQjE77gNJ+3d8DTxujXiDbIG3L/6mzWv0Yn1E2GZAXuuftE+771TvxQ3cPDgonYzI1tJsR5KrEKgDupar
 w//6FguQ
 ZxrRExjspNxKPH0wf8NINYvmdVyz+spYFrmvtCfp576JNwaFMAkfZhdMocbDO5HDfbr8mHX1/SqE+WOJXzPUfPYyquULjkTJct9VwiLRfI5KmsJXmPdoCeSjkz36oCWgT9r14lW6EcAI7VlEBnvwG99ekbVjltQJGQZxR4EhG//9Dz/LAcxmd3IevfDL7+TjKh7cJfRABOb46AgWipVC09ZOZJF298z8XyMRgfjl7Q2ZcrPnH/oigvpE7sHoEK3v9FfYSQGPQ8Z2UexqNa6nLl43+9ExJjrX/+OxoDMtcuJvJCSpf5x7tjicSBzummTuuo53nT6JxH4kovuw8KsaFGDLdyG0do/cK7FblXA7g8r6bJKMR7MVcfcMA8CYitcIP9HXTPAty5mzj+JwJe5PZYvHc2cImBRjn9UHXM2wWjm0kiFR+YRZa8YUBPyT6IdHWkiF/Lv+121IwCb2aZaGkx4pGX2dGB03dlVaUhN+oPFLhWz+ssly1Hn/l4gBubrhVQ1ufbNSZvWlwDLCd+cy9mFs8YVP5jZsSmxBPjDXGQ6ReRZUMFjKSCaPzAVXqjkDolrAgD9wCBnnKCGGNVyw7g6JFeMGmeIJOoOqvw8Y1nT27/8XRm3yu7y9VSUuqgqjCsT4ARnMpeCJKIPMuq/YXf0thsUJx1k0KOpM78NiohrlU2rJ8YByO9jSj/czS9QldFc99ZP6VQEOTGT32aYDRcA0AGmjRMq1OBAdNCglsPQrSONlHrM61ON0EuaDtAevkIiB+3MJeZ7WtW5gCu9j6j2DrcIk/TkuNqhvD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250827 11:57]:

...

> > >
> > > The exit_mmap() path used to run the oom reaper if it was an oom victim,
> > > until recently [1].  The part that makes me nervous is the exit_mmap()
> > > call to mmu_notifier_release(mm), while the oom reaper uses an
> > > mmu_notifier.  I am not sure if there is an issue in ordering on any of
> > > the platforms of such things.  Or the associated cost of the calls.
> > >
> > > I mean, it's already pretty crazy that we have this in the exit:
> > > mmap_read_lock()
> > >    tlb_gather_mmu_fullmm()
> > >      unmap vmas..
> > > mmap_read_unlock()
> > > mmap_write_lock()
> > >    tlb_finish_mmu()..
> > >
> > > So not only do we now have two tasks iterating over the vmas, but we
> > > also have mmu notifiers and tlb calls happening across the ranges..  At
> > > least doing all the work on a single cpu means that the hardware view is
> > > consistent.  But I don't see this being worse than a forward race?
> 
> This part seems to have changed quite a bit since I last looked into
> it closely and it's worth re-checking, however that seems orthogonal
> to what this patch is trying to do.

I was concerned about how a reverse iterator may affect what is
considered accurate for the mmu/tlb so I thought it worth pointing out.

...
> > >
> > > There is also a window here, between the exit_mmap() dropping the read
> > > lock, setting MMF_OOM_SKIP, and taking the lock - where the oom killer
> > > will iterate through a list of vmas with zero memory to free and delay
> > > the task exiting.  That is, wasting cpu and stopping the memory
> > > associated with the mm_struct (vmas and such) from being freed.
> 
> Might be an opportunity to optimize but again, this is happening with
> or without this patch, no?

Correct, but with number it looks to be better to go with two loops.

> 
> > >
> > > I'm also not sure on the cpu cache effects of what we are doing and how
> > > much that would play into the speedup.  My guess is that it's
> > > insignificant compared to the time we spend under the pte, but we have
> > > no numbers to go on.
> > >
> > > So I'd like to know how likely the simultaneous runs are and if there is
> > > a measurable gain?
> >
> > Since process killing events are very frequent on Android, the likelihood of
> > exit_mmap and reaper work (not only OOM, but also some proactive reaping
> > actions such as process_mrelease) occurring at the same time is much higher.
> > When lmkd kills a process, it actively reaps the process using
> > process_mrelease, similar to the way the OOM reaper works. Surenb may be
> > able to clarify this point, as he is the author of lmkd.
> 
> Yes, on Android process_mrelease() is used after lmkd kills a process
> to expedite memory release in case the victim process is blocked for
> some reason. This makes the race between __oom_reap_task_mm() and
> exit_mmap() much more frequent. That is probably the disconnect in
> thinking that this race is rare. I don't see any harm in
> __oom_reap_task_mm() walking the tree backwards to minimize the
> contention with exit_mmap(). Liam, is there a performance difference
> between mas_for_each_rev() and mas_for_each() ?

There should be no performance difference.

> >
> > I referenced this data in link[1], and I should have included it in the cover
> > letter. The attached test data was collected on Android. Before testing, in
> > order to simulate the OOM kill process, I intercepted the kill signal and added
> > the killed process to the OOM reaper queue.

Sorry I missed your response in v4 on this.

> >
> > The reproduction steps are as follows:
> > 1. Start a process.
> > 2. Kill the process.
> > 3. Capture a perfetto trace.
> >
> > Below are the load benefit data, measured by process running time:
> >
> > Note: #RxComputationT, vdp:vidtask:m, and tp-background are threads of the
> > same process, and they are the last threads to exit.
> >
> > Thread             TID         State        Wall duration (ms)          total running
> > # with oom reaper but traverse reverse
> > #RxComputationT    13708       Running      60.690572
> > oom_reaper         81          Running      46.492032                   107.182604
> >
> > # with oom reaper
> > vdp:vidtask:m      14040       Running      81.848297
> > oom_reaper         81          Running      69.32                       151.168297
> >
> > # without oom reaper
> > tp-background      12424       Running      106.021874                  106.021874
> >
> > Compared to reaping when a process is killed, it provides approximately
> > 30% load benefit.
> > Compared to not performing reap when a process is killed, it can release
> > memory earlier, with 40% faster memory release.
> 
> That looks like a nice performance improvement for reaping the memory
> with low churn and risk.

Agreed.


Please include the numbers in the change log in the next revision so it
is recorded in git.

I think all my questions are resolved, thanks.

I look forward to v6.

Regards,
Liam

