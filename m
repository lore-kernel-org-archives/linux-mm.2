Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3220AD29DE6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F366B008A; Tue, 13 Jan 2026 02:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832F86B008C; Tue, 13 Jan 2026 02:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDBF6B0092; Tue, 13 Jan 2026 02:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4E46B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:48:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3D621401BE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:48:40 +0000 (UTC)
X-FDA: 84326163600.24.014325E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8543B120005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:48:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B6RtZNmc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KdYP6ZKP;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768290517; a=rsa-sha256;
	cv=pass;
	b=MuaNE3g3uCSxXTzDh60MbjRelDxJlhb3Q1cQpaeBQCEmREElukXoGz1WdrL0ZlbYAROPkL
	C94QECiQRHwpNYmboTDtv6yLpteg/Yj92aGfUga8BsTZOPhTbz/p8XtDhaGM0REtKHholK
	tkTu0SkOfrAWwCJXe7/7Qo+2C54vCpM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B6RtZNmc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KdYP6ZKP;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768290517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFToMjQQ6Er8C0U8T2/nrnV7R0wAjGq26OQJzQVWyYI=;
	b=GU2sfiSWVX38suH2jPdN53+rQLaAzIyg0nFVnibYGLENaPg9c5RZG1wKAC8nMGmTsyeNqY
	XWmFpLdwB86cixYhzy3BuRvcvlHqoYxPsJFnkreG0kVRuhlm3/Ln5cXpX743peS2Mw/t0w
	1rnfDQLR1U+h5yH19QRhyVxIDYJrEhk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1hH1Y2677746;
	Tue, 13 Jan 2026 07:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rFToMjQQ6Er8C0U8T2
	/nrnV7R0wAjGq26OQJzQVWyYI=; b=B6RtZNmc2O2/vAYb3yhv4pfqST0/dhYIhY
	/cuBbGcnBXMEank5Td7bTEZSvM+oIkKqbQLyrU1LOjjGQmwhjiGVbFExyEHp/Fal
	R4RdSQ6yYEKzozPxSMWgjCfxRbjAOy1z2iRjs2aA35Hc3XhsM5pUvlDmVUVhvFFQ
	DBwDsFwQg36W1snahnNF71wWo8tYxz9Ud0ogawCkJpgdktFC8ZhIBDUlh77xaCjb
	J5ENPWcEoVjQ/7GAhTRM8F8wBMhUCN4Xl3J4JlvWAtCuU3ggMl6ysl+bpBgCHvoA
	c88FB4/oipYUTMbmAeOFCQ+enniaJKGoaewp11eQWovZkAn1rNmw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrgnu07d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 07:48:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60D5Urpw000532;
	Tue, 13 Jan 2026 07:48:25 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7c699s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 07:48:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cc7mVAMs3kPkCLaZN0KfODuWuOvwXyj2/CZMfH2e5TEBEncsKV1iM0v6s0WHgfOcZt586PJIyA/4LI235khO+1XKyjy1b2ssuu5KtVguf2fVWHUe1PlvL+YzC+gqfA5ybTykqwOqZ1oIIacbsJbwl+usr9RK4ZGXOI/2Jk2RQrBp6qRSbkJIpaYrAHFjAaLX56UN6Vs5genf+jcJ9jDJ9/PDn/FHs1kpmt8b7uwq66Ar4W5coZ9CDgTfhP9Se8iZqFzt35Dq0MQosNTJKdussoH7g78VIzC01DpA3O7Cnvq04weoYGagoZzd0Yb6djmHRhOgFZjz02diMzib5lXxTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFToMjQQ6Er8C0U8T2/nrnV7R0wAjGq26OQJzQVWyYI=;
 b=GT4Y1A4aiCqW2WJI7l1kPOEPKTw8Oa/Oy8vwLZ3zScBJSPR9nEl9aG+M5ybQNKY/4ji+CUstPMNPhc0uNTZ/cyJ5He6mJbRFM75uIc3MG6DzyLj719NYe9rw7nHjQvjZbDzhASHzLqofiaB6q6YwhM7MVneBlJLyax6jzEkXOKAAEKHO9e+wAOeWi1cfSaPXtp/klBcxfUm3y2kHIjNxXozusPOAXgge4EgpVlPSGMyiw1ybh/s6l2YNyFbPksOql8O5SlUWQwyzkxTp1yWCGtXZJUMSIpv4drpan0Mct99O/3SRbEpBt+3bhGY0u+687+P48n6cMHnKRtNbS1PnVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFToMjQQ6Er8C0U8T2/nrnV7R0wAjGq26OQJzQVWyYI=;
 b=KdYP6ZKPBDeIGU8zsblOinag5q3vLff+PzCXuTkA9WgIZBiO8w9sz0o1t2a/yUe4HC5lNrhHOfExU2KGCxJ6FLPTDHMmvKkQxNbwP8UWNsqURtYzFWS8A4WkH+SmdP7kLPvFz3nhR0BnSTtTrfhaaXQPPeuEils6VJNYgQo5NvI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB7153.namprd10.prod.outlook.com (2603:10b6:8:eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 07:47:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 07:47:56 +0000
Date: Tue, 13 Jan 2026 16:47:48 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
Message-ID: <aWX4pI6XVlPPdZ9U@hyeyoo>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
X-ClientProxiedBy: SL2P216CA0158.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e06a958-8995-4ed5-f32b-08de527810d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pP4GsYaPCHa6dzyHDiefpXRDfy+mxVHGakL05zJK8FIeaXORYCn5lsF3mCOJ?=
 =?us-ascii?Q?gWfnUTLdv/MQh7gFV3rAIJQrrq0OZpX+52oWdqVjsQgFDH8WXZ8LJIY83l7W?=
 =?us-ascii?Q?rvIIIhCck7cVMHHuAuftHm5VITSyYH9PKo2/5FSsSI1IF3Nu8nUp2AOuTAiN?=
 =?us-ascii?Q?XgGTaQIGkg6vgQvjBZfRkHw90gZpJgoXSZgJEAzrIkhLhFdLQWfQg3Xg5q2o?=
 =?us-ascii?Q?WSc5P0ruym7R9tmaLdgi17Ctm16GUZkYE2cinkIXKma4Uje/tXKj4Ig05DUY?=
 =?us-ascii?Q?rOmhODTH3df5djslOxcqr8+ieyr9TlOs0bt/1HYB0XL5YLBvkWWV823wcJDQ?=
 =?us-ascii?Q?taMVaOZEYijA+LC/ALpB/cZQt4ybeTuMS1reRhg0BZspuTZJBNi5HAhj4vID?=
 =?us-ascii?Q?Q9qUYkNBl3C6tSDdDlif7bx/xyH3PfOtM4ZDUGNlP99BX68cFb+sdWkSXzEF?=
 =?us-ascii?Q?5P2N0Q6RYH/N3+r1U8LADhGRBHUytwss/JJW4qfDHBXlr/nCvRoAWQhb7ofe?=
 =?us-ascii?Q?LDwdeQ6ssvjyXa24vlgSGIiJDk8b2o6Op9f99HfDCJtw3qiinjX6orCU2d27?=
 =?us-ascii?Q?SDnG2bLram6RBtyZB6Kw1TBGGBVGuRQEz5m9pdmFZe6qhsyeouGx/BNVkPY2?=
 =?us-ascii?Q?BMYFh1+/o6+9Vgw/Eie3JSvdyJFva4u+QOsBZnPdjCuhjCesMh2dNxKnXIzK?=
 =?us-ascii?Q?/gvf0meyeOdX+k4IxsjeAcXtUTA92P1y4Rh4G8Hsha9L1chBvjDoHqS4wt2C?=
 =?us-ascii?Q?hhKm1WGGry+XTbA4dSWafm9bnHdKEytgMKqD8ZyCf/TZpya4YAhWyXSAVUOy?=
 =?us-ascii?Q?m59/vqB/XGzjPYcvpEOyvNOihnEuQSgNvgmpnIb3vxreiF/LELJ0CcGaA7H5?=
 =?us-ascii?Q?Ri+/Qnv4keu1039dkKgslape93v8EbCRO4mZ/DpJI0QBuGYCx14KMTGjhga6?=
 =?us-ascii?Q?2390+HV+OUQ7sUPx2dvo6D1WnDigzaNaKPv62NUYVcXFyfPrnWd+IC9XFLXy?=
 =?us-ascii?Q?42c26odjimJEX0Nclar29jX2SCU4qbYHb5HefGavIT218pJDJGcnHLo0Hd0z?=
 =?us-ascii?Q?bRcRoUpmOH9kkqbRhyf3gjpPBIuXjRLSmg2n9vr4sxbydxxjxsFqu5ZGKR2T?=
 =?us-ascii?Q?yCIE9tM/4aICMKdL6pAUXq2UqbZ33F/UVmDcs6FFSdEVdXh9z6jJHpmGwtA7?=
 =?us-ascii?Q?sPtKQyVCD3JsaVzxzYm9lvY4ujMAzke7heRshICCwJKbM1YkfxFE6Zh5Aa5X?=
 =?us-ascii?Q?gOweV9UFc7Ank+Bncwl8D6jauMqrAX1ze7/Rp6CEzqquA7gpycIuwXEKC6Xc?=
 =?us-ascii?Q?pk3BPueqTgGDb3cJrA2zYB3ePPaPddb6afxJYkWzXI7TAJWDqlByoNwehrry?=
 =?us-ascii?Q?5kl2Amxjg1nTBuaGIMqwMv/vj9T+1gpYl3w1/WTNijQHF8La1BhTqy4Igo3E?=
 =?us-ascii?Q?z6kmkEsJfabOEV5LqJw7+UefavNJjTTT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YZam7icro9YCMl7JG8Hd5yHGcvJMAqkXtsFMTO/au9rHV/kVJvYgRCq1P7ZD?=
 =?us-ascii?Q?oQiQj5IojzhBOi/w+3mvMenKZJFVWdqFs6w6hunloCsMU0z3vLDH1PKTr6a8?=
 =?us-ascii?Q?4NEL9ehEB1nLRdXeZLnkf37gEO1yMH1qT14qrXLUmhl7fJXZ1iat3PVaK7Hv?=
 =?us-ascii?Q?QXpeLvdjmJUkfPS0PTOATdGgpQHM+JobRQ/PDz1SW0fx8XBdy9BPU6/0fdPi?=
 =?us-ascii?Q?nxCs0tqMhaU1eHed2RRL+iTd15oVxrFRl07hMksKybEZisLbV/DzhdM2xSEn?=
 =?us-ascii?Q?PEI0sOUnQcwHAYVhlS12tCl8TdELm6sOJCeJ6J+H0kAGEbc+yykb0dJ+oSxB?=
 =?us-ascii?Q?zF/kRJDPrcegxNkIW9x+G4PmWWwLM2vbu8kVPBkGgmILzjGB0nzjuhIZGLqQ?=
 =?us-ascii?Q?sEARomILaKIKQYUm/pnxYsvC9gr3YVnk96MUFLrXV0A/1InBBCJXrgRqw3/M?=
 =?us-ascii?Q?pRRcMY93Exe2C6Vz05ZbL20+42DDYe+qVq+x97RLKD0JHUf4/bACeQVlwbyg?=
 =?us-ascii?Q?6GmcRZsi0jHxdnJ4cRbpqvEFd0tBb8Z3N4La0nzrFsmCIn12A+MhedjTTieY?=
 =?us-ascii?Q?vTvWJSVtmISa8or0ebj0Xih3/VTgnhR83BQpt3QFnZjJZaoIl0ys32YVGyTu?=
 =?us-ascii?Q?momgBo+QhstCQNtYYtKG1/Oyefv75Tw67x3PWSZIRZBubotBmpQdwxjIj6wm?=
 =?us-ascii?Q?aiv2SoC7W5sH6zp7bQEcFS6uP9Xwv3wUHlCgEUufH2QmYgYINywZ9IY7ubNW?=
 =?us-ascii?Q?Vgk2J/8J4DIuxpN6VnPUZuunBxfxE8s4g2eMNOnVpdewAQ+wCX+vbG2gEtvb?=
 =?us-ascii?Q?c+sba8ehripT7ccWalMpmdZPH9tf7i+7ZrmM3yrWDW5mDNMEnxTyrREHJ12i?=
 =?us-ascii?Q?XV1gpslU7691W9zCT2JoQGnkKJzekhxIfm8P+uyA8rtNMdrmQHXksZuxi5mv?=
 =?us-ascii?Q?Mv54W70R3/9YwYo6ZtOhvEH/7CPh+DEnyLA8eAnFhAlWFTyIIGTaQfLHpvbt?=
 =?us-ascii?Q?RpSzygL/xObKNRpqA4NcPLppBZIGMt9RL2uUamiOvtphysaCZ3ISqmfl99ip?=
 =?us-ascii?Q?dLku6daIcqWcnWRn0EPQING1pOEK0bA2fDQ2A0eHHOysTJcTc9+lCd9Pt+D6?=
 =?us-ascii?Q?RRkv3A/VJ2s30/onTn6262ILi6weVfCE1D6ozr5r1MVfsR2BA+Cs0A1pn3uN?=
 =?us-ascii?Q?jeYaFjCc3fZ3yoIcEq1vm9F1GDTr7HTOhZqCJml2EMs2rRSJ29jtmRtHCRiQ?=
 =?us-ascii?Q?T97n0IMef5cLlEVhhCjcQvHg2eIXOozwWi5U6+Cp4rG3J05XHDg4usf0d8p9?=
 =?us-ascii?Q?PqmcSNXLYqgkWusyXfou42a4yczrrt3yhzaFOP0Ik0hWxg9IU03eJUyzbmeU?=
 =?us-ascii?Q?y6YVbI5x7pwEPwQ0+ClAosowg+/JoFAd0fi3XQQhmkUEidnZdGIo3cBOEpxl?=
 =?us-ascii?Q?uTAtobkIB20WY3GGIpKmI0jaUDk09Kkfo5OO6BhILxue6RAjX+7VKMJcwX4e?=
 =?us-ascii?Q?gU9vKedwbAmt/rvThdX8oyh/1LdCutH08/ogLrayBa8F8MDo7FnppLgqFIIq?=
 =?us-ascii?Q?TMZ0IXVRETlwQKdie2JkIynFIe2aFUek7FUN9DKpajy7AMALsFVYq4eZWN1s?=
 =?us-ascii?Q?guIhFN76m0zbqcT4rGs8N1LURTED4+BP2WtX46X2Z8kjjEZrC9wFetb/YJcs?=
 =?us-ascii?Q?HIED2+mcFhxSFO8tHZf3F4MHVgewGABFu+uAS4oODTVQ1X95ovgtAJBnUkWJ?=
 =?us-ascii?Q?8VcL9ixdDw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zRlt4WP+zYvDJaFJ8is18Lhav4JRRGAaeLMFGj6TFRuBqhxVfuDB1hVyCPcLViI5WSAyx6HPbeD9E9gdhoMoGyfDRbXimfE0QmZEsi+inodVrM5lvFEBIZbr0rM6c1QEkTjQD5/E/Yz+5ughvq3MQgQ7aOkBTtjqZJSt2G9HD6kWKNg5G7uukoTItgCjEVfc3h2lWHmLFRE5lf0opnW+OD21d/WEsNk6CquPLh3oFb2uZ0X8FQwhc2vBMNIAB9ad1RJDAlNCeZf4AQGd4Gg+lK5NEkhVqqSmbIYwl3JLmo4ROGIo99RhW/ajy2blwZWWW/k3r7h1pIoHEDrIdEIzSEs9+26AAQ4OM1T5N/H1tq67xilcq0bqkZknY69XYvYsFqJAg5U3pb207BSy3db2uc/qhJVCwFSKgvi908UdlAUX50tK7Z/+00xwg22RbHU99A61M73SAAOyr4u1cJLVXfa+kChWyE2N1MpM48C0Ul/aCObH83afzMiZd9tEAFwcoU6zBMsLV3cp9jTM9bJAQYorlY5BkoJ/gHJcvoozaFS6cdkD04lqX4VkAt8Xc0paeT0DXeLTZRcIXwWZ88nAgQ0ydy/GBbcUIO4TI2aDeCA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e06a958-8995-4ed5-f32b-08de527810d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 07:47:56.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTC9IPEbKbd4bE4Cb31R4AGYqVXn7NHs+QOxFXNocWxn5H9Rm2+JxZbZuwN8LHxEiQA0twqUraxC33Nz1Wu3og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130064
X-Authority-Analysis: v=2.4 cv=B/G0EetM c=1 sm=1 tr=0 ts=6965f8ca b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=j2CDy7_qB3rhMwV3ThUA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13654
X-Proofpoint-GUID: dBAUjmuHoFpaCLvNjx6YNHu3f1RektLp
X-Proofpoint-ORIG-GUID: dBAUjmuHoFpaCLvNjx6YNHu3f1RektLp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA2NCBTYWx0ZWRfX67/l0ecRCrrm
 AGuF6NzkhXCFeEWi3+yTGeCO9Lj0mNn6KN9qzTjV22zMjVFu7VS0vnreR5ICc36fIslRsqwv479
 MzDAeKIqdcuJHENwe0b6t+tDHVHxRqkdVAVknDFQeLSGq8Da09RGS414fNJ3bv+rVxEXJmmRSDn
 pY/PwyCYQfeewiA0oKvKyTxMNVIw2823hOa7P0j8XWL1RjYWe7/Y9LCHZz6Xge/1/l+y7ct3b3K
 veSFKEw/PuWL1DkVTmOp6RMg0QbRVMsoZDF4VAyJxbELOB0oqUx97EGj+3eaBEGHo6QXUe6M+M5
 vZKFQzUWXLi7+eb2k3e9jbPJGldavFnQAPCQhX8WhP1Ot/LkgeUnbYCL2w9HnbPBgUgaV8dD2EP
 1zW+6wIQkulHlwFRzHfoWtNoPqDz7opw150XwWIx+rGX7rQxa5bs4F4WPwG8J/z0khraGVssfKS
 Fs2JcggX58Pp3EonpQ4D6BsWKG8M6eFVg/IXNqWY=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8543B120005
X-Stat-Signature: yrghxpqqpubmsr9s6ecjubnr5pddzjhc
X-Rspam-User: 
X-HE-Tag: 1768290517-5528
X-HE-Meta: U2FsdGVkX18tf+Hs+RYkMqymoYPYol9pHTVADpjaRU1VgnhUSp6n+5y2m8yAPbSNxvB9KDR6QG6oOUmGgtlUK/UDNYHdTlYJSjagcTPQ7/m6o2qE7SSe2rLeTEmtafz375Rumt/YIwwKPjQPiXVXVR1u6quMsAYYuZeCCatt/3rfJJDMGfvdVB8ARd1Izr8XWw/j1XPvrxCyHFRM6BcWZO6QGNWflLsRqaHmYUR9FwsqmkhkwUF8Mj+rSJ6R1bcNHnsiuZCfoLEJbpveigCHrsv5f9mpdirMyERT3YvpQEQDd/DqaGphm33RozeBRWF5F0swVhm5H5FnqcbgpkvGMAAv5iQRhSGEugJ5gUo7xpOlmimurg7wa7LFkdNgZ9b5OsGE6HKc2owieY+ISJ+Tz+SrLLhJy1O1RVFHwybW10mkE55R2n5jjPQ+oUqnlY7i6KX/CR2euuiitWeKjP/eKYM7MYmPO3dfK9GITsuWtV5j8tjy5EGsZJjd++W8SS0sS2w8+6aWpT/UAwfoLh0r545+KXXmJaXRgppzrRCd4Zz2OuaVd92KebjpVDozEdfoEgsnJgc8hHgjuDfplsNeqHqJeCj30mffL/Yfk3rq92wTjsfGzb8W29PfKgkzsAeXIQJ2XlyqOXY3LtLUmJzwJtQNjdLiehf8SN2P52iVDLe9UI1QfTHG5+AR/kzUyfXLqLqAuKC2Nn9NdDxmOPLjuAoPuIW7EFmTWWZ3lXyd5UvbDiidTRidJd5KB2YOk8dnkyxywf4Uqy0SuN8MJHqSUk64fdBGPxl/HpFfIFUygeM552Wb/DIP0aeZKY5cgVEm2+y1dC4+Nr0sck/I7Y4LuvNpuW2yiDflhfURTDvW0SAX4IclL/MaSYTQ2ULTS/DC/qw6sV1nrwX7ajUs2BKuYYIjPQtqbs8EIj9eQSb0n4OhmCqB8yRr1laTl2pkrD2FswN192N32ue1Ox4FKlk
 SFYiglwn
 aHqEuiCcUYCrO9lmHlerrWZoWbes4uFRaYHgAvP1O52S4NWx8ysBF4fVAEFyx9zMt8ztt9ibjIgP83il8KYcNM/fJtl+jbPkPiqWhuBwHlfXNx/KHF5uPIwaLvq/wvJiN6RlQKAd8U2AsiDyMRfhUWudoApCSMh/MjJHZILaSIBTZBZQ1iw/zZ4/Bf5sZDDPAXJZx2Gz+LNRYfdRxM+OBDIamwRjBb6g/hG82AEacWpMEAHJJ7WvfGFafORC80ZI3Ngm2p4TbM2RUL4W9ySIFDy/a5+R5LiC7LU1J4kSeAhUatviny61REi0VWmDiYvRkNFKVNVj5LRS9GdCyHttp0wUqSICg+PhBa7+enknHukXwrlpgmhKQwnwrd5pBpFafC80FmQXkkHafPUEi3T1PTa2mij6b7r1nWUPfmEJFtLk3lBVEw/sgjeXqhkEuhWchvHgnGKCPzc5U8VbE8bt7lWRzJh97NDVidWx12JOBf8vddRq88kwnXgLCzZI/82NCQbMtFQ3bqRZ9U5J3K2xq+OX9WIr3hj9VxmX/c96Fa6V/pgubNgkpzZ4G3vPltq6ncXwrPwCKXC1E/D/VLQXYG/sL7kxjWtikBpchzRy8AvX9uqh6bJw6UaSKSJ01VARrlmA9fJgjzYPmmscu+B2FScHiTdTDh4YdQVWvL5XspxDDJ45OvRqlTT+8PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 04:16:57PM +0100, Vlastimil Babka wrote:
> Before enabling sheaves for all caches (with automatically determined
> capacity), their enablement should no longer prevent merging of caches.
> Limit this merge prevention only to caches that were created with a
> specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

