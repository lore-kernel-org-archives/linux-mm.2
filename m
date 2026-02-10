Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154ECE94626
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8206B009B; Mon,  9 Feb 2026 20:45:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B736B009D; Mon,  9 Feb 2026 20:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12C76B009E; Mon,  9 Feb 2026 20:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC47F6B009B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:45:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 666C813A212
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:45:02 +0000 (UTC)
X-FDA: 84426853644.04.432FD6F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0046840002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:44:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kf/smB+R";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TjgnK8pF;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770687899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kb5W9Td6bRG+eauC5TyWyfhoorZdpnNImWoX0XAToc=;
	b=drHkeKDFqxkyyswcKmLLg7+s9VDttMcke23r0ql6E4pDW4H0poR/hBQFrSapMSeMh0Fq5w
	3YaiNvuImOs2x5edd0IiE6NA9QOk0toObPiAo5AYyJUxsEATi9xdq3et5geVQ1jHhdvHdT
	tuMAdJLh10iWAfPe1W9MIxO3AQWAms4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kf/smB+R";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TjgnK8pF;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770687899; a=rsa-sha256;
	cv=pass;
	b=5Tzn4jRi9GZG8z+Ss4FrRAdFavZHJYrR4DaIndt8P1EdpLIuK0pC9JuxDwNhFfbRy+5aNm
	0PmBwkUWKqjrdCawh7Hu7v/usiaqkgC2IDK/WQWSzVMEb3mz4qUYqKyw6jTsgOr7jvEtD1
	evBxXCwMqqh26EONpc8P/g66gT4CWzk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619MLAYH2021213;
	Tue, 10 Feb 2026 01:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9kb5W9Td6bRG+eauC5
	TyWyfhoorZdpnNImWoX0XAToc=; b=kf/smB+RN37JghC408ZORVfKCaq1SpDXVJ
	2DyDkIf3DLWW9VQTEZ38qhgnq7eaP+xSWLIO8F/X4ywkFcAKGyROy0H41FA+/9Ra
	T10TmXVjriBdfuMKOd+UOdz98iAGqgvkR8/rul0vg4XToRyBKpaeKcTt2Yi1YnXo
	v3mpoC5GenZJrs9ND0fGh+UxRsGwumoY6ATgXs/e26nb53wSefb+YbqppSZAXrCt
	ifK3IdaZt3Pv4UvW4gaZd1YttfIgknkY30PmNS07JIzbrcknAEUlGn5iuWAyJ3w1
	eb4SAC3kwkBgWDzTFlQpzp9UWSAEoabyri1G+hIz19KpSvPZ9BSA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp35r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 01:44:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619NdZg8031135;
	Tue, 10 Feb 2026 01:44:50 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uumb8qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 01:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oMbhFBxiOsIKv2X4gJnNsvNznOQ6YtxdEbp5NjGvk9yAEK59/rczNtZjCD3arqual9rpCqHQOqDZaWeFvle/p4stYfrxKBHyhZ3W74kSqDO4oMNgtNloF1626CpabWq+RZFE40oGfMVLQ1IRoY653hWf/aUHDkPwK0eiID7a41Q+4QHngwUiatukrhm7pkSFclyTV49K/HfdLLnupNW3cUcj6TKme7ss2zk5cFC9f08HId/HOgq+h/hTTH9rvhB+u3CFFdapQO2TQREqmEgkRhIe2mH8wYoOvoyfwm2CpaMlwp4AhI+9c+TvvBWxCCeyqGWFuRvGH11W3h5IjpXwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kb5W9Td6bRG+eauC5TyWyfhoorZdpnNImWoX0XAToc=;
 b=O320r/+Vv09idjsqlO6Gh6biQqA5ImEHanI6yYKaHZ9EcffHW/rPvVzl7Osmca32rqWMui5zYGVQFKJBmjh7C9zmCst1jVhcw3bA6iF4laiK5U6y/IHV2qaiF/UTEaX72JI9NCmLzy8Pjw4blYIBFlwrj4gjaLAyP+F9Q8eofbRgatffTHf5cgWlfc+Kk8sBer630lyrk4hS0h+ffYptxZLixdoGeREa2uG9ARmNBDDXYY1spwC5h8MBeQoN2cUMB6SNMt8tWqkHYVKhuJK/5wViblKQ7xKfTHo3GgSgivPnqMmy2R0U9mgraPyx8kxMrC87rcAZgkcNTg8IKS1u1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kb5W9Td6bRG+eauC5TyWyfhoorZdpnNImWoX0XAToc=;
 b=TjgnK8pFxw6JXlaObLMX6OJqY5InzGKuQe/quzHoEa0I7FkzoLQ2sGdSY/RbHfihs5ZF+HGQc9XjR8ZvynRxTEmhtSMY3Ac0qongZL41eKJzglPv6388N3b0kulZZ223bWjUNqKMqakt1RwSH3CkPwrorT0FlamJuI6j/nhIm8M=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5082.namprd10.prod.outlook.com (2603:10b6:610:c1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 01:44:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 01:44:47 +0000
Date: Tue, 10 Feb 2026 10:44:40 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/slab: free a bit in enum objexts_flags
Message-ID: <aYqNiD47P-Esvdjy@hyeyoo>
References: <20260209121013.50475-1-harry.yoo@oracle.com>
 <20260209121013.50475-3-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209121013.50475-3-harry.yoo@oracle.com>
X-ClientProxiedBy: SL2P216CA0124.KORP216.PROD.OUTLOOK.COM (2603:1096:101::21)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5082:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f956df3-ce46-41d2-fcae-08de6845f8e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FTZAFr25kQN2oc2krKfsvMe5bpdteko2fJj+MLWRIRxXgZd0IasTUgIgH7VI?=
 =?us-ascii?Q?gTK98HV5adihP+NYuvYbeY0D0Dc7ETfdcYY+6YEQwg3AgxMh63gXHlEO9eDL?=
 =?us-ascii?Q?T8+p6VTxBjjFBg9TQkoiOQPTKEbqiUt5ySpQUsdAauVw5fXdUNyEMbsSrr5m?=
 =?us-ascii?Q?3S3cJNhIL4nb1u9vIW+3aIeFvEStLcUGe4D6/zsl+oI5qikTTDaUx0wQGoKa?=
 =?us-ascii?Q?mfsCPiyzcqppWzYa+fuZqUf8uYYSTl6E0fFCQaVzliiwWYzTlwEgQ/2E0Mcx?=
 =?us-ascii?Q?V84WkXC66OvdTT6e+xm6DCJaHspuzDer3Wx4FlMGxSuQYPoFuHunkvPhTdeJ?=
 =?us-ascii?Q?v4Z28LHDot4LhTMrB48pXHwHZlixkkiRrZBMolhIfR+OTEvldafdrAAYv8NC?=
 =?us-ascii?Q?LJMRb8jBhG2auU2M/aIrM8G3yRG/ZdugYap3pKJeq8GIG55BEPuUGeogN55/?=
 =?us-ascii?Q?GcUtHgIlzq59k9Wa3cx0A53IzOVCYxCjdvvo9QJ1jfdVAz8T6Qq1y4V/jvr6?=
 =?us-ascii?Q?2EqxAZ/+GkR7ZVSm7+YMXUsFPNtOUVhrrIVsc/jiiotP6kFiuA/2VO6fGkHM?=
 =?us-ascii?Q?Uql3erQqwzkb99L4rVln7ey/77hc33K3YpLuPQp12bqGpmOlq+9c4T4idamJ?=
 =?us-ascii?Q?F0VK/GS8jj6CviEgyZnP1N8fRMICmIaBwxtds0HmGh7F9ec1Cb7sAC/RZfEO?=
 =?us-ascii?Q?bAvvViTTEY5KZGR4cPUt92CxEO/7ktTDvbcOjdQG06/090eOTg6Y8FkJLeQt?=
 =?us-ascii?Q?/ZtFR7EIsId/2kSKDQfoeZKeUcCqCPNMX0m0iZJWgUpmjUpO0zEl9MiH1nzu?=
 =?us-ascii?Q?WycUOSgaRcCaBFChSu6nyaid7SEzobOkfOE6drMH3j7c8cYw/jzUQ5FtZgpy?=
 =?us-ascii?Q?y1FbxVQHYC3hKFJyrrloXEiXirjMqVV2v3KN3yxh0zRefk2Hu2AK6qmKEEaz?=
 =?us-ascii?Q?QA5XhOXuGked8xJGI5G/1tXD0VVrQNvMOjZtLVyQityE90PCAWag8YGCLLg2?=
 =?us-ascii?Q?gu/WW6YwCBr3peq09PhDEyAgYiPzZktcCdReeUGOjhWRv/WCxZw08R4dvrBP?=
 =?us-ascii?Q?AcblfJs1M2U6UKYdMIEdeE5KKFj4Odo/4CbGLOkyUjyY0OxfQn7INZbB3wvr?=
 =?us-ascii?Q?xyvd8eVa+2YzI14x9fG3ZeWFb8w7TSEGLE71z1ikqV1eTW5TIFbUZu5dDKBi?=
 =?us-ascii?Q?Dt0W+ycbNr9NE1isGQDq+9FhUt2LBLALIjHxInldOqK6lKI0xfrbroiq4WdE?=
 =?us-ascii?Q?X/mrnrRejib39JfdA1MGENiL5UtpBdy4kptnzmNC9TXNMBCXcW80tDlzvjXI?=
 =?us-ascii?Q?7MJ5oLUpKgPFnRjg8lCgwkxVEUiEdGTlTz8z1szzOiyLXs1D4mLsVGFCaE28?=
 =?us-ascii?Q?zJH3T69CH8WY2lWHjt0UYVfoWn1BWASlwbRXLq4TNYaOlK8ykD39dSKUO8X7?=
 =?us-ascii?Q?aw5ryrJE8G42pHJBYHgDrPJvo9vn45cksN3V73OTwp46u/l/NENKjt0ZehA0?=
 =?us-ascii?Q?Sy0HUgNIyf4qp09xPyOO4DyN6KlrcYTRL6BRY/EYq+ehe6AZtpS++qkeB+i1?=
 =?us-ascii?Q?0bImtIxHpmV6N79RtJE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x3DW0qDuzT9THWQouE4AkbQe0n7sI/xd5oDJ9Q2nHtdKw26TTaoYckLBM6NU?=
 =?us-ascii?Q?nT5DP9njNoDgkGZNB+H6uxM88EX5aLy6DppSAtrlPBG4uzdOW762gh6/EvI/?=
 =?us-ascii?Q?WViGUJaLW+IA/RibvTfUnpWzhGf8nZoWqzVM9QubZSoP9FlMzXK/C9PzzpAh?=
 =?us-ascii?Q?Pm4BJ05UYrN3u8gpWYXhpU7S49H46lPUYdR4vaneu9hGR8WrYh0LzrNlwIkt?=
 =?us-ascii?Q?6jKMwoIWX3dvTr7K+tpxlKV1FR7Q2fffPVaY+be4VRXGXVqSMNb4K5WjUY6x?=
 =?us-ascii?Q?kIiAOQttT2l2X+JICc/ZuU/d1Uod4AV/MXygb7zNMXzKIjsXspaVYyyxnr2D?=
 =?us-ascii?Q?tO6BsRxiBrTMna36wEMo8njUM+d1Rg88m5sNlZBTASjzzS2i06Baln4IuTf9?=
 =?us-ascii?Q?YUg8LTT/7oRKCKe0sZEFavCRbip2RPlWcGPXl9uWSeD43Bivyhcc3EQDZ2S5?=
 =?us-ascii?Q?5PRt8NglQhcsGn2yCdQv4VgfryajMLHRR7Qtr/37PWRkfmqsY9Q4BdDa7D2S?=
 =?us-ascii?Q?GZEyF8nx/sQfu37ax2lV1L86V238SDqDgm1x7orhMakNS0k42h0orSzb43fX?=
 =?us-ascii?Q?xvjkAc/HoxK907tEULKSZcUpIFBWr5VofBApruVjKD4VniaKZgGKns5rc04C?=
 =?us-ascii?Q?Y1fnMGh0VyRQgSeK8mUheBWOzlmM57M9jWhAEe+XBs9cIrYf12eJNL1ieXPU?=
 =?us-ascii?Q?xLOZINOIx07WRuQyOAj45fvjD7wqiMD8qKUGM7hoBNU3hqciszLt+Zh6gkGv?=
 =?us-ascii?Q?/et9pDVBfPijyyQhgm2OAA99EK0iziFJCbhWvxU7UGi7WFCgJr89P4HpfNoC?=
 =?us-ascii?Q?rkvGpeHHIs7WPd7HFbgupX4Q+3E3d4PJY5hb/KB82OEdzm20u6Mn3WwBExYc?=
 =?us-ascii?Q?hfc+Yge3wGbzPSSY4DFotqfw3VBTSdFMyg9rTfEb1I3ZTzET2ezlrN8mcSm2?=
 =?us-ascii?Q?TlshK1AkvMKfmML8bPxqzRedI89eEr38Em7buVIryUTNmexjy/pVVZneorNy?=
 =?us-ascii?Q?lcs7Xy6K+7pDgCHDL1A2NY+Z/qa5LGjTAI4VWMp1S3k/V/qAfw8BATUZogjH?=
 =?us-ascii?Q?wcPeX0DKHliwz1UojLgLSzy9v9fY4qdFK9XpC5qmBilO7BGU81eTO725oudc?=
 =?us-ascii?Q?kIAQhhTToPSxAUd65JoBPFuuGTBDvOuVveUp4Dc++/n4Lxsg3zVlixhBP3O7?=
 =?us-ascii?Q?VJ99KWJFXR7AB8bbq2lUTPn8pH3RYx2LuRN7NT7FRa7wCcD+Su6LbB5uxUqZ?=
 =?us-ascii?Q?3RbnEQs9Dzn5nyXzIjcjvAjB4n3NtIeFbHcihk8X3dJKBmkdlO+gpE7B5S1v?=
 =?us-ascii?Q?GNOsoRH7tSqHuTZdxEi9XjmPSkgdBYrTyp4+X02K0DTz0WjrkHLo/ybFLK2t?=
 =?us-ascii?Q?QqhV2BSY2ZxMoCC/COPMEaEIE6h+5srlhLh71m9X0mR0662Jg2i5Nc1xD6V/?=
 =?us-ascii?Q?WzGQdhPilpUQPfb5rR47HmBbiZ2ea/4LwWtp7ELP5kGQN+3t7PtYL01Nmzba?=
 =?us-ascii?Q?XqeAKSBW0gbIBIECNGS81eFHQ/zue7MzN2Z2cln4JEqjS6jDQp/FofcX93Pr?=
 =?us-ascii?Q?/FH0wLRkSy+gXhxdTqARI52v/BpXz2HMS7cJbkk3RdsPl5v5t6uRUJ+OiLdL?=
 =?us-ascii?Q?CvRI/YjZIZ0D1h9EsMsallLD5KciJ3S0Qtwox8fq5JBMfgrXGmnjIs3BZbJr?=
 =?us-ascii?Q?SIIx2Aigkhc3v34kTIi9EOWvpu7/UAmHJWOS5l5kJpntMQ82zn2J03cUX8/R?=
 =?us-ascii?Q?dMRvQLjxhw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CLbEHcwTypA61mNgIBptT5AsckfVm8NxfmiUMaIyeuQWZZWzdTVbbnrqtvBhi2cD6leiI8h9UQAAdNHJIVRiUcZLueGWf44MOd1Azbb+tv9vIAj0CJJm7tr9zKQJFKh8QxapmcP4A2xRMiaMg0ApUbjX++5MIdXJmBGkY2x4TFx35sgYZj8cduw6JDxoB8Vp7hvANX6Y30LPDkWB6ICzGTFxLIP2trzWwXqJK5/uslGuykdyXzDoKInWxnWb5shVmqXSSwwDPFPfxWEiEcXLpXAjMlW/gDWC19FaCe9pfHmNTa0Sya5DZLNjUhxKB/T12DxrotTuRFTtnm/QxVAMf8HqtlHYihoj4+uxTKSuck0Ux8sEzwJCutemsV+6KDO7dgJ0idkbHfoKhd7KCQwM1mN6HaYkKUCub+I8A/M8lc5E7aSM2Avs+OE6kAd3SDBnPyjh7687KpirMxumAR9YBM9pfZUEVParcEPbgrxFDb5c6gbFYeHCxFu8Mhs5KE01aELScWdjIz4u18M3Fsqlcq46VKk/SeLPcjI2ngJ1iXa0ppEHLClhXo/UNxIgkKTNx9IMjxXoM0GqaWS8PDxdLqRcushcsh0VU1YWGcNKaMk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f956df3-ce46-41d2-fcae-08de6845f8e8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 01:44:47.3609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5Fik7aZAics/OzVut8NoJ9cCXveuQk44+SICPWR42anpF784JSTyelhQPzI9Z3G/XBnrVamtF93fQLj/t5Dtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDAxMyBTYWx0ZWRfX2LxrTiVuGXn2
 JOvFhJxtctXlVwCiG+a7wSzg9vAD2j0oTccwb6jCRJCib3FWtlgUbQabnzpDcADO8YbjbTCgQo8
 fKD1aIGB4uAIkfLwJwsiK+tzirTHFbDsjtr9ZmN80BO22VUgcwC4vnvYNzL/BTlvQdmMgYjF0Kz
 yeqzgr73FDuAPHoEoCBrAmQs5Z2HFciSh8qjdPePDUepWxAUHd5K9hzlJS8JS/FdLTdxqQlme06
 8eWfKo64kLilkPjcNTptsuaX4bacWBZKKjEB2sNS8jc7txklQahA8pGNXoe3P4P70chAMZlfz6I
 WyOALO9eQJS7p8upDw+6zBWLWck2zgoxUsUViRflMtvebm64kgT88CZ6HyjBm72o9EPJRKfvmm6
 Jm4k0uV7uZ6+qZjCXdnebvSvGKDy/6w7tHcSLf0k38gjO5a9acKyJDYmdg7mIMhCRmD3Bj7LLTM
 q18OdhSd+bXQdH4eSNcimJrJcOjk0q1KCOIihWFg=
X-Proofpoint-GUID: h_TvsxPJywY-EkrUz9OCpUzMUFmeQK56
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=698a8d93 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=zDenyLsJQZmnmW_C_kMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13697
X-Proofpoint-ORIG-GUID: h_TvsxPJywY-EkrUz9OCpUzMUFmeQK56
X-Rspam-User: 
X-Rspamd-Queue-Id: 0046840002
X-Rspamd-Server: rspam07
X-Stat-Signature: 9fkwtf85c9wbmtss5qb8ga6kda1dm191
X-HE-Tag: 1770687898-274885
X-HE-Meta: U2FsdGVkX19EfwreMF0g5ANsIG7/Er/6CkmetRq7wCcFbwvyTTtu+FY/uTWkJzSziSUUgpU0B2rtxgjlQ18J7n0cl0uPgrLT9r1T63hr3UC3SMF+fiXsoztZN2iQbLyWvXi6RdJuLJMoA16op5rmh+QwH2A2sGjdVJLIgm0mFPSYXB4tnt090IKPYi7qOytfH/5ltCFR02QpBP0QKWX85+dKqCKfYSE8GrlXnugUM/Ac1a4PyLHcpuODSkl75f3yDakdX+KtK05gS1qI6WtB/mJ0QwDRkncIUVZEOq6GELgMKwvCGjMdHWSkqYamGNrgvUtaIreXK6Bu9SM7vy5hIqpn+dWOtW+E7URi5bsPUU9/O6h4IUaLdCRlzkTh4Oea2bj3jryexV7o08Vaj65wnD1n6Hl68zCisW4mC0GWfaJl/OW8pwlvUyS3rUlYFFeiiBORbRVRw45ceJeHRPUpiMJ6PERdVk+2oseQ2HDdZFKguto13y9gZlYrliU65N+ugamTF5xuaVcrskQIlJhKeFxRYqFe5BvxSRQY//sIRY9jDOK1o8emMb5TNz1AtjQ1scsAteEsIsf/G4hNrhoDNO6Y5NBYMwY3/OXLvdG2kxx+BDyVxd8j/iMf9npEenEpkLZjxJRJoF16RVInX6ADFmKOQ/kmcIv1FcIWkFzIO6etmUVf4HJEgq/kyq3omq9O7qYCPjFviECLovK+3dRMPCgmACidbkgCpxaJkNbR9/4xM3ha+Yun6g6PEhoBF+v6dEduFGLvZm3Z7oec5muicpELc7jzhhqaTkjF8WOwdIzPU8W6TWlf6g0cLLmaFMQr9I7+iz06xC7CbjkrUczLOjAufphNHDFrsw9/KeA8mx5/3W2TL+rh1mDbtagFfV9mqeNa/4/kl8solx6s9vUOnNX/Bomwpoi8UgFK19oDYyfWl6SWkLVPAIH68B31enLT+/IpnzS6YUWw5Fdb+Ef
 9mTIzmqR
 OVXM72H5dNWfI5B5/tRQH0+Z6ifawi0fClZEEIUdk8kN0BdDBzVvKhy+lhjiTN9DseyHAJPhiJTARE18bqWLQGJc48VUD1R3AEu/bgvWggzAVnFWt0ik/RWKjv+XsdBvELZHO/uYcyKdSOhWrd42yl/JqHAluThdKW974nCqq9SHBtAdKjGWUth9gzQeCIlSCzkLczMpndUZ3vP/vsArk920BElj+U/zO3teuMdD8EGDtz3scHqwhFlLotfdYcXJStmzo9ghDSmtYrD4vqocQuakgu67CgLPCJkwRxBGsZH2WoNRF8SBwoBIN9eeS8f7/izO+91RaNk91/SYW0J8zdSSrGoc4kODWBjZMWhxa6q3xm7JV7VtUVpalzwdcyB5/CjdLfs/MpAITMzRk48pYanN4iYYtV8MSewMiocISPqpYNctWI6JIuuS9An/4pGqIlocGrJY8L5yi373sv3oOpJnxKnljENUKryeUihvXMUMlbynKS5v5eddWFKn8cSycHUBhciJeKDUGlIdJv8CrcmnEJKRTalVIUoAfJOdyXa/k+J7Bx5PsEFZSYC/Hjjxn07ztVQbGZ1jrHqpAUqxzqTzDEQawZE+vDXWnzueyo1GfDIdg65xUofiBOroh30sKUR/N8Xfip3EHJ3D+/8WM5fZb4nhnSp4UH9HNCSl5JGw/H/aV+y4p2AvmvsIVyK4LanzCkqFTi3Pp+2san+vuiUO2Siw7LyCsYvA6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 09:10:13PM +0900, Harry Yoo wrote:
> Since kfree() now supports freeing objects allocated with
> kmalloc_nolock(), free one bit in enum object_flags.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Oops, looks like I forgot to add Alexei's ack, and...

> ---
>  include/linux/memcontrol.h |  3 +--
>  mm/slub.c                  | 12 ++----------
>  2 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 63b03fd62ca7..33d2cae8f939 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2213,10 +2211,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		 * objcg vector should be reused.
>  		 */
>  		mark_objexts_empty(vec);
> -		if (unlikely(!allow_spin))
> -			kfree_nolock(vec);
> -		else
> -			kfree(vec);
> +		kfree(vec);
>  		return 0;

Oh Harry, no.

We still need to check allow_spin in this case.

Just because you can free objects allocated from kmalloc_nolock() with
kfree() doesn't mean you can call kfree() when allow_spin == false.

I'll respin v2.

>  	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
>  		/* Retry if a racing thread changed slab->obj_exts from under us. */

-- 
Cheers,
Harry / Hyeonggon

