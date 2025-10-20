Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47458CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2C88E0025; Mon, 20 Oct 2025 10:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A828E0002; Mon, 20 Oct 2025 10:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9420F8E0025; Mon, 20 Oct 2025 10:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82C0F8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:12:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44B1D1A01A0
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:12:42 +0000 (UTC)
X-FDA: 84018683364.05.E3662A5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5D651C0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:12:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pnVIvRVX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P3582lXy;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAmNDW+yxAq8Q81Ydsfben1tGBq6z1hgCzj9jnOL/vI=;
	b=QxXhHrcOhyzD9mmtmvJ25A3aT+S/DEwDPpNYYtPtpvwkkE9YTkajtl2WoErYaNNLMS+ZvU
	qe/eUvYeeQO5Pd8FJKDDOocBLQTSk5tqPMxvRWZyHLj/J6AUvHIk6JlwTohNbnWy4QPEJ5
	ER3k9FPsXASiEXBNAJ6tT0jPgPO27NE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pnVIvRVX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P3582lXy;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760969559; a=rsa-sha256;
	cv=pass;
	b=yi6SY/95Sl9Wbay38qhgEKy/yc4XxZXu0Yn2e2VUPTIUwUL8kCoQ0o3vXCidpQPl4Sf43D
	sGBNSVX61J/XfwArJNFCjkArB7XqtuQS9RUeVoXLEI6UEaz3UIjzif80lhMbx47DOE7DDd
	+eI/VMJImcGNqSoeT3fSSiBfveoyEHE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SIjK001407;
	Mon, 20 Oct 2025 14:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JAmNDW+yxAq8Q81Yds
	fben1tGBq6z1hgCzj9jnOL/vI=; b=pnVIvRVXcUbrYlh/3H5Nq13VNdrQOxKWkB
	kasWILjkP84ZcZkyNodx065joEI21uoUOPIR1MHT2/7gRxC8y2r5ZAXLCe3isbUe
	yEb0V1OTQ9zxe9MFDKqB5slqeDjpQw8tyEupcnvCcGFiv8ch7iYwvhgGjTD/8orr
	0PiCe1+bNcFVf/8OgyYIST/ZO8wvB9R5m4FMK+E8vria1dSmnVm0mRMuHxnTkm65
	RJVxPosKqzmUQUB7j7r7UO92OiwH0Rb1jgAKxNbhGwyZ753u50Cmr247F0QaLNge
	+ai18BTvYgV49KF0xsfWzQ4bYFg/w5ccL6O4PmYaVwgmm0itU3Dg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3072b7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:12:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KDdJXs009331;
	Mon, 20 Oct 2025 14:12:33 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbyte6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:12:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Df09s6emAgA2yYNy5NZsuRg2PxQAZJtw8Hnutq1w9X/yK94XQZ+Rck0MFhWYwWO8qbIezYzc4Du9HbjzHeuVHwyPg/K32+V4fDVCi3bOYAxcbxK9ljRao+oYSQ9a9h2UhGURPoHYDX+0rAlHuV5S0AVQSLLLRx7rSJ1xVDkSDqq3Jgn+yhvGFEvHuYb2pPuzzERw4JHJG6e6GJDH0BUK2qqyf0SR9hbY9VrvoxqQPzMOBxmMLqOsV8uzwDYOZwa/HMJrQHMk8tCkZth9rmr9wQ88KVUPSPQHNVqrlB175h+iE/PVxyVrwju1VOLMjTnJM6yRoFu074zwQOIk5T02nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAmNDW+yxAq8Q81Ydsfben1tGBq6z1hgCzj9jnOL/vI=;
 b=dWyNeHOztMf2W+NjC6WxX3BZ3suUuL1EkMsy4iY7jJj3RHAkTauP33IQezUeeJjkBfle+Z4h//SPSlSq2lJtjRgfx2D+H4i1PgGvRCSlIC34oFK4E5UiWenschNPumStdfmmKylLn+pKFoE9KWLgU+wtB0aEKJ0cIPj5ep5a6OTsxacd5C+Y1HipZBTOywB6vvDbyWMHIzWUvWKs0S9hx9zXxaGlFLVkF+kHVQuCTABdg1utWifdd+7YLFeppENMzqedXeBpQngnkKHvgdVHj1Ycx843l++S+wa2l5QSlcnzzH0nNxZlPCDyV27DM9RI+28V1VGwENjyyQlqNxp5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAmNDW+yxAq8Q81Ydsfben1tGBq6z1hgCzj9jnOL/vI=;
 b=P3582lXy1xCmRIJxQUb/nXjIdcntXMkZSTr5WqC2YZPR1Y5cWLuE36YfgczO3407TJyLndz7QEALnVTGjjgITiNLvlZNRpS98cPEf9GlmeP9PpHZN5ZRFu3quxPz5cdM80Y4sVUR+0FiSVmurnsce8+86W61MdaeXARi979kRlg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7669.namprd10.prod.outlook.com (2603:10b6:a03:542::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:12:29 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 14:12:29 +0000
Date: Mon, 20 Oct 2025 15:12:27 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] treewide: include linux/pgalloc.h instead of
 asm/pgalloc.h
Message-ID: <9e713326-776f-4499-a6cc-e3405544598b@lucifer.local>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
 <20251019072509.9488-3-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019072509.9488-3-harry.yoo@oracle.com>
X-ClientProxiedBy: LO4P265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: f29639ce-33e6-44d6-936c-08de0fe2b43c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7u1lIfbczmcXwwNDvRVOkEhF8yhME3n9N0sP1lmYGUSVfMrCDxJ7OBjLwra6?=
 =?us-ascii?Q?3u77eiN5gdaiFN0KHUv2YCFimE3QgVosGmfsDcgDkgtZ5xdeE1oKFsTOroTQ?=
 =?us-ascii?Q?EjkSX//kc0/oFcvdS6KdDq9HgpjWeVTJaE8m79j6fPBBs8t4dBHj/VBSx4px?=
 =?us-ascii?Q?jccXUOXSj0dDxhthWDnpLesNQaNKyqm5tNWfUZjboTYfZxQm3fH9NmPeEX/A?=
 =?us-ascii?Q?ShnTzt3zzRYjWih0saOM9EdhYehWDnTDzFh1jvaozsE1DXAZLyE5SOA8Igfi?=
 =?us-ascii?Q?qaMY47Wjhiqh9X1beFavndj/kS2eGN8Vw56tK+ZHQ7ByNA6NP9UG8qb5L+WN?=
 =?us-ascii?Q?gymte0Ce+WVzYZ8oD7sg4f37cAl0o5pbjT0HvOnLUU+wxDSpAVAPDoTwUFJQ?=
 =?us-ascii?Q?reXO8TmX7CAuCBS06IRoR7F5m4kp34Sqy7QALPqpTVAWn+aQwuWOnZZqzJ8X?=
 =?us-ascii?Q?LSs0mE4mWd/1T9msiYXrRTDAMDNsHS7UvN7d2/lJ8XVEixDQZoNQr9XVbAta?=
 =?us-ascii?Q?1xUN2HoaD97jLrzNbPHNT3sKAxzCM5R6v4d5YoLKJF4vHORph0gGtzP7tlCn?=
 =?us-ascii?Q?V/fMfzm51f+I/YidZLeuXz/pzHVgcNdL3f48ptuX+q0wEMXgeu+tmJmKHNAk?=
 =?us-ascii?Q?D5CXr9xpptkNoXqO2o7MTyQG73r2O6aod229O2ZNBTJlu4SlzxAOJbqbBkHP?=
 =?us-ascii?Q?ZUBm+wQEyknbUOQNH6lfIxNvTGAtX+Bt7Y/bWElFxj0BJljBEcvKHYUmbfYy?=
 =?us-ascii?Q?aR44ncJ/7rvVlm3lAcXBxtDnxfghZniuOEU0iYKvfpNKinWiHq6V403e4ypm?=
 =?us-ascii?Q?pk+Rn6WAhAx8D1Ln6hsAhAZdcIzcmgcvB4wF7al7G8htiV+dgaDYHf9x9OBh?=
 =?us-ascii?Q?JPBLsM/Q+k1+MSvt+iNoy0wcVKLNz3imrDKi1iInjEhvzFj9T5+A/32XeFTL?=
 =?us-ascii?Q?fQW9QMnN0dZnzWiiO7BPoi1+/6pIRr1BSeMOORFMxhOH6iPl6ybfdFNZNeH0?=
 =?us-ascii?Q?6/0nJBlQOu1e6Vr7UwrEjzwuo7ZLb4Z66/SSIAlD/qvoZg6pkFo2MDPtPrwG?=
 =?us-ascii?Q?Gd62UFDHhwH+1zYO5q2hVpPijD6slUnSqetot8xQlsVommNr3r1Rmz8kQOA5?=
 =?us-ascii?Q?ydV639JsOGk+5B3Uk71BkZK9E9LjdfsO311KS5SuQP3jhQ/9A0TFGaZEnxYl?=
 =?us-ascii?Q?6ZX2lXT20QeXAhrCh+PpBh4ElKGhOoTFBHBiA7Sq7i8/ndQjc9gZp35XOmSr?=
 =?us-ascii?Q?8N7jMoS709wOtB0aMcPHOjfAtJJ+G2/2Ob7PrwdX0yGZwwN4AL/IwN6pu+WK?=
 =?us-ascii?Q?Ulc5SpW918ytX94nQKgo6iN60e9j5DcurGk2SXTGetaRHAoNr5mZX7yXCjqv?=
 =?us-ascii?Q?blzxj41QY1HyJ5kyOq7wzsvqnUGlp2mUQqVBVUAnNsdc7Q9HuXoq2h905ivp?=
 =?us-ascii?Q?xmQgVDiMXAD9f7Bn8jZ0sWDyqXauYnXj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a6y//KIDldGAu3vYtqYKw5lvp7Wpv3pTZRyTvIgCAE1/jwTq4sTBYu4K54GA?=
 =?us-ascii?Q?AfJ6EowCWnlSiWnBJ0k7E4X0MuW+crBNb7kQDVSR8JxUIfDgAYwYlRZy3mV9?=
 =?us-ascii?Q?FwA1aQkP2Im6xHC+vsdBKrkpUV8wIW3YYRk/U6S042M+uPUNKL3ZGEze+D+C?=
 =?us-ascii?Q?GV9uZfrxFi3MkjlUEPv6wx+2frwIEKHOodHe7Koo9JiII8+H3GjjSGKFh97g?=
 =?us-ascii?Q?6GccElNjja8PLRY7TkTOZzgAWMIoP2w85sJTtdE2WYKA8MWsel7MYfsO9ADo?=
 =?us-ascii?Q?2ktD6jbbU7UTeMnouvEzXr3GICssATAsT1a30z10wLhqUgK33uCyepHBdHCf?=
 =?us-ascii?Q?bNWLbFSeCdPWpyHEbLo3xNbcYLZ96A5Q4PsyhIjhBqLQ9wr7FxDSjTVP+dWh?=
 =?us-ascii?Q?3Z3qFGUNxGFMtYvv5/7EP4bnsJsPiWsUjOKrPVOCkvoragGkHKeTwo3Jogwj?=
 =?us-ascii?Q?sl6cttuuuDhXhYHwdLbU7h22c59ki7ZwrHtsJZmjaKHscfSepSDRwBiHCKQ3?=
 =?us-ascii?Q?9kBmwEW2rnV3gOs1OPPH6RHhwChR2mCZgvrk/LD2bZqTd6MUCjaTx+2ByVY2?=
 =?us-ascii?Q?ivvMjjUC6zJPHE09LY0I4rFlI0jfaIbjXgzDvPF3belVEQC0h+3O0Emtv+pX?=
 =?us-ascii?Q?diVwZi05Gg9XY+sijtQtslUk8h/di8SCYvBWxDp/tz1MVNX7Qee07nVOk2/3?=
 =?us-ascii?Q?Y+F+KYy+bjmYJRIkMG8Nc8xgZaaiNdafdYPUTa8d1a8cy7fvZhs8WIyaAkTy?=
 =?us-ascii?Q?m1rGuI6IE1gptko7bs3+lCdi18aRIazU4HCZ8W0In6qJxX96GuXJSfhK0axd?=
 =?us-ascii?Q?8WxNlUvYun4AXHn3GvZ2UEzt45KJlpcfzFBdpxJ1Kwhc+Dc9rASAAD3JV8Jb?=
 =?us-ascii?Q?5nEU56i4WTboIEA+IBR1HV1C1rW5C4JxEApfKzVkxtJu4J6K6rcOFbv8pb9T?=
 =?us-ascii?Q?IJLNQ25hkCilcPol949GwYBP7OQaBNlwLou26SzAu23tIKCsmTJYJXSKTfRI?=
 =?us-ascii?Q?NwNrCOTXG02s6nXDjIsGO4pjnLnpiZYRkl1lcm3344ZQBrt8/932vDnOWgYG?=
 =?us-ascii?Q?ziIGd3IcYm3QiT9re+/uaMmnZeXzEzXu0ktLZ1EzossEuiTN1Y18RgZQpTwg?=
 =?us-ascii?Q?Cfj/q630VAdHuZ3xPGAURtQwgISP0D3o571R3vuBLDSyJ3g7h3vhEQX+S8m+?=
 =?us-ascii?Q?oP4gTjXq0DWqJ1MAC5AxHBR//Bgb+McZd1IUIA67KZXNHE86336US3W/Upwh?=
 =?us-ascii?Q?DjgBsTKB06SbYMjlHp6vb2pvJbU2NXpyoaYQEsHkfgACr7f/7en7U6WM9/Kl?=
 =?us-ascii?Q?e9PxDT7ku1+J95HVpseQCwpwxyLI3+k2rolOo/UoSYpP1u7s2HIhffBKRxSk?=
 =?us-ascii?Q?rZQH8eppo9PN74N3yn7OfAYJm+dJLprN0gFHl8VN1K9noEzs26dw+Nj/fTtT?=
 =?us-ascii?Q?KPHC1qTwBToqAFTABffoOHw3W/xzsp/ua5T6znZfSCvHkCvMpPgDXYbBZDod?=
 =?us-ascii?Q?PNOdcoxyKiLeONAjRIbEnIVdVgQVbTbGwZdLxUFezkZY0j6rgnLz3KHYzdcR?=
 =?us-ascii?Q?caxIjijUA/0CH8II88Y0fG5LFF0LO3QDgcuxjJHcu5SBYK1A9OBWKL0MwR57?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VauLKE/K+rI1LqyNybyKj7OMDavU35v36vBmaCy12RS6nwHf9C/YdTMPBuLCN0/0PrXRd16w9LfVJi2zXD2GZOZDPHG0uQtXaDIDBXI/NZDTS7mHnjqw2BQpvXjd2UR9kGrAgduvu0iCy6HoDEEyx5coa4QtgQ02UKog9V99jglLe417T1x6GRvli1UfWMZUMCe6tuEnIwmOxf5LppZooKz1iUrY2gxaEBNm5Yz5MP9wuF0/EkePVxkkD53LT8bfyg+Od2OvkoTQ+XtMiI3+ybZTTEIqR1y2OaeYlHRwihn8C0GPsm7rkKjTXP7eEBiv6o8a2TOTE5wh7HHsCqPLBN1uiUjuDS/grOQgco8EdlzPoaT/R4aXoE4KYqnpp95apBi5WUWNp4RTBCm8w3GLgDyocfD2uxEL3OvztgO8etMwx4k1Z2IFK9ETlMm0WV6W7pt0G629kh836XRfA2cHaIVSB19OndMnCHs5WckdzlY76Qf/II4cz+tb94IVQMHiadyLOzhOB8OGJzophQ1O/BFPH5HPalpNzZfpAePOSCOFGqSfjPU/UnzkTmU/t3d7xt8eYjpFw3ojqa6/hs/HmKCj6sRfkyvZ8oPJiMus9H0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29639ce-33e6-44d6-936c-08de0fe2b43c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:12:29.4746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lYmb03zXi91k2fIk4AwSeK3YA2ik64H/CB51AsNkNEIb3ZkJD8MgpnrW1s6Yv74ZAQkHPaF41WuH7Lb+T0xkIxy3TbPQ0LUf11D+FJYFfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200118
X-Proofpoint-ORIG-GUID: 1jwZelxDy0daX7M1haorNgNntQrI3tVw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXwjAYFWOxJm8E
 b33n3fzETKyV8ftykmkXpKsbcSWABiRkyAaV3WErXdVKXV6LFeGkf8AAQ6DZvJBazsiU4yoiOuD
 /Cll1ab3t4VRQx5QFHDtA6yh449U5QpblbDw6Th1BHCbwzKEfINd6vm/KZdt5AkbhjjoPoLWBI1
 Xj8V0Tf7G9dwucT3je28ZrE3kwaP2BBHSchCogzDno79DaHOCyC25cMPJFFsTkStXv7vDiSOz9P
 DY6LXr0Qma18BBfeK6OGe6C6gksKjKkcTUkCupW2inFy9Kupgt6/AEnW7OtkkoBjoMTcaY9OKED
 ADpwURkvdttYl3xMe28MvEEUVE+qdvzC923NOwsEggATuvCM3qlpib0qLgZ9pDKB9eVjG9+0dOg
 KpBhW6gZlrNYIB3dxch0L/ppiiSDAc3ivDdeKIl9J/SD5xMqy6U=
X-Proofpoint-GUID: 1jwZelxDy0daX7M1haorNgNntQrI3tVw
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f64352 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=ZCXTmdebBlu_TJ6Qe60A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12092
X-Stat-Signature: m918nodedcwrcjfiqt95p6kene31jo3s
X-Rspamd-Queue-Id: C5D651C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760969558-105147
X-HE-Meta: U2FsdGVkX18byPsrGFwzogvnGl9jV9mp/0k3fNW0bTNNDPf3Pu3vSL8jv8vboUhXwc5rPBBleopwPXiywa12H/UTcHF0ydC2lkTuTy+beCJYf2OWAxlPMvJDQasSf8ccv0+9lErm3tiZxjeiuQyPBH4Sh1FdgHS4K7M7rmTfN4wpTWYMXb6ZbOgqUWJOgQGCvaeLzmcmXs/J4GyUslb/PDBWS7VLb42ZuPlUt8W7/jdY55kIbgyrlAVleFzgHPdlbMa9yGLkzVAyZKpJZ070R8vCOk5k4GdFZGXF0dxeZINdezFVUUFkPuBgNSYUx02HL+0kLdO0swyOlzqXlKFALJj9zZ9tHBGF6WmGWuRa+vz3JbmraKklsmMY3j3GNRdYbtLKiWQFeQ7FJhrpWsRujsHCVZZDGk+XvXM1mdXOXV+en+kRrPu6/M8srWGTIK78E2sYeFivrlUBJtQzpc5stLrTHyUEWaphXlGfk5XNug+qMRDVQ9ciXh/D59xRObV6zEnow8ipzoltQfGHgYs3AHrHHyz22hyk/fpfQQrzxS+MEowYgXFNiyp1Ak1+sr/gHNKpeT98oVmkBaPL3TJUvlxK/paV0XU/KUVJLnWvpy9S5Op7Af2SagNrKNqq/qDokdvggKI/QwFXAHZjlN50ENk42LNZSeX17aYbsy1S63RLOxNH39rWuymwmLVZQDGj3zbQckVZMbOTjPFlLcu56ktGRbQ6uYEwpHzX+Ye0ixqhyZeFsdlVK4vd0wqGja412tFXPFbrtwTcAC4PQlIjydVDlCpDamaDNd96+jdrTmVf+l9nCZsLfKegww5c1yxwrJxMYaGaiQcWD1O8VZCP2EIPqmKYoACNIua8M6sP27gY0KM0Wf2I6eX3X6iciYQ2LCBJG7O8PLHlXZUMbIHkETsy0QM9lMVKfL3Z/xzC8oY2wKzMZvVEVKKeZC+TlA71thVni904SURskEjGA8K
 a/98NLv2
 YHzvdndKUupf+07dGo8xJBdX3Yv8hv6VCLmXRq5Hd07MfWxT9v0FGnXcOltqmC9CPsv9M8gCNR55017uk12ZbTuxfbcw0UAS/HnHBokKpXmlwRmEFC2antwIVVTsWjB8slTLdh6Bhnm8afGxdEuTzJUMlWgRQHAaFA7V+s9dgMoBYhR/CSW8NNJ9hU0zLmRyHRkplYUgmSVIsPIW5e9gJT/jluGZvi6gagk3Twl/S2vHFJsxf5l63pI13mZjBD/vRx3d/qxHeP5V/xp78eePW4AhllN7BF+q4wsV0FIE0/2NpVysr9vOYFE0qNTpbsOdcBOxsEKoW2zS5xjXlMYZcBjLZfGkMIfLjGSfLeU0hWR7vtHuYAPB5KvfFpQMLbxcF+52ZWXdsfP1IvQORx08FxAEBnYCuL8cNOeuMOlMC4crm87g6yx91JihP3pw01VpGhLYjKjr9Cok6q+5rvSpIvxIlvIa/w67lf5htg3W3GLJUWiBW5tznewmo3eop4CgX9BgZGLG5kYOoMaK2xa67XBIagfizCuDNC0lbRQlCb4R0W46ap5z3BBA61daR+lFtah03ve/Sq34Oqoodk9oVYxGPUra4xbeh/LG89uqNtqit6ux2481c6JscBxhuGVoChPpc+MTABYDrdyHeLVl4lU7PjEtrPI8QcBPe1L3nCX/Qtv4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 04:25:09PM +0900, Harry Yoo wrote:
> For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h>
> is technically fine unless the .c file calls p*d_populate_kernel()
> helper functions.
>
> But it is a better practice to always include <linux/pgalloc.h>.
> Include <linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Thanks for this, LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  drivers/firmware/efi/arm-runtime.c   | 2 +-
>  drivers/firmware/efi/riscv-runtime.c | 2 +-
>  drivers/s390/char/sclp_sd.c          | 3 +--
>  fs/dax.c                             | 2 +-
>  kernel/fork.c                        | 2 +-
>  mm/debug_vm_pgtable.c                | 2 +-
>  mm/filemap.c                         | 2 +-
>  mm/huge_memory.c                     | 2 +-
>  mm/hugetlb.c                         | 2 +-
>  mm/hugetlb_vmemmap.c                 | 2 +-
>  mm/khugepaged.c                      | 2 +-
>  mm/memory.c                          | 2 +-
>  mm/mmu_gather.c                      | 2 +-
>  mm/mremap.c                          | 2 +-
>  mm/pgtable-generic.c                 | 2 +-
>  mm/pt_reclaim.c                      | 2 +-
>  16 files changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 83092d93f36a..2e3b5131df32 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -19,11 +19,11 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/pgtable.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/efi.h>
>  #include <asm/mmu.h>
> -#include <asm/pgalloc.h>
>
>  #if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
>  #include <asm/ptdump.h>
> diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
> index fa71cd898120..5b8d72885fee 100644
> --- a/drivers/firmware/efi/riscv-runtime.c
> +++ b/drivers/firmware/efi/riscv-runtime.c
> @@ -21,11 +21,11 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/pgtable.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/efi.h>
>  #include <asm/mmu.h>
> -#include <asm/pgalloc.h>
>
>  static bool __init efi_virtmap_init(void)
>  {
> diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
> index 129b89fe40a3..7a791cb35aea 100644
> --- a/drivers/s390/char/sclp_sd.c
> +++ b/drivers/s390/char/sclp_sd.c
> @@ -17,8 +17,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/async.h>
>  #include <linux/mutex.h>
> -
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>
>  #include "sclp.h"
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 89f071ba7b10..1c78fc02462c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -24,7 +24,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/iomap.h>
>  #include <linux/rmap.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/fs_dax.h>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3da0f08615a9..9d48646e659f 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -107,7 +107,7 @@
>  #include <linux/tick.h>
>  #include <linux/unwind_deferred.h>
>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..25a823bddb92 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -30,9 +30,9 @@
>  #include <linux/sched/mm.h>
>  #include <linux/io.h>
>  #include <linux/vmalloc.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/cacheflush.h>
> -#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>
>  /*
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 893ba49808b7..ffcdf4f81d0a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -48,7 +48,7 @@
>  #include <linux/rcupdate_wait.h>
>  #include <linux/sched/mm.h>
>  #include <linux/sysctl.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include "internal.h"
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bfb52c564fb3..b4d18172cd53 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -39,9 +39,9 @@
>  #include <linux/compat.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/pagewalk.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/tlb.h>
> -#include <asm/pgalloc.h>
>  #include "internal.h"
>  #include "swap.h"
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 86e672fcb305..1ea459723cce 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -39,9 +39,9 @@
>  #include <linux/memory.h>
>  #include <linux/mm_inline.h>
>  #include <linux/padata.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/page.h>
> -#include <asm/pgalloc.h>
>  #include <asm/tlb.h>
>  #include <asm/setup.h>
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 96ee2bd16ee1..69d71e048e16 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -15,7 +15,7 @@
>  #include <linux/bootmem_info.h>
>  #include <linux/mmdebug.h>
>  #include <linux/pagewalk.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include "hugetlb_vmemmap.h"
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e947b96e1443..cb2245085879 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -21,9 +21,9 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/dax.h>
>  #include <linux/ksm.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/tlb.h>
> -#include <asm/pgalloc.h>
>  #include "internal.h"
>  #include "mm_slot.h"
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 19615bcf234f..449d3c312fcd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -80,7 +80,7 @@
>
>  #include <asm/io.h>
>  #include <asm/mmu_context.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
>  #include <asm/tlb.h>
>  #include <asm/tlbflush.h>
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 374aa6f021c6..247e3f9db6c7 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -9,8 +9,8 @@
>  #include <linux/smp.h>
>  #include <linux/swap.h>
>  #include <linux/rmap.h>
> +#include <linux/pgalloc.h>
>
> -#include <asm/pgalloc.h>
>  #include <asm/tlb.h>
>
>  #ifndef CONFIG_MMU_GATHER_NO_GATHER
> diff --git a/mm/mremap.c b/mm/mremap.c
> index bd7314898ec5..a7f531c17b79 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -25,10 +25,10 @@
>  #include <linux/uaccess.h>
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mempolicy.h>
> +#include <linux/pgalloc.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/tlb.h>
> -#include <asm/pgalloc.h>
>
>  #include "internal.h"
>
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 0c847cdf4fd3..7b50efe9c477 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -13,7 +13,7 @@
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
>  #include <linux/mm_inline.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  #include <asm/tlb.h>
>
>  /*
> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> index 7e9455a18aae..ec6fe4eb2644 100644
> --- a/mm/pt_reclaim.c
> +++ b/mm/pt_reclaim.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/hugetlb.h>
>  #include <asm-generic/tlb.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>
>  #include "internal.h"
>
> --
> 2.43.0
>
>

