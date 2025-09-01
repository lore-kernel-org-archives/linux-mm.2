Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5CBCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB148E0023; Mon,  1 Sep 2025 07:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2538E0016; Mon,  1 Sep 2025 07:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289F28E0023; Mon,  1 Sep 2025 07:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 133A38E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:59:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A75351A0716
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:58:59 +0000 (UTC)
X-FDA: 83840535198.20.711A39E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DA78180010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:58:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z6EfezPE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gvzOUx9N;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756727936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAQ8lDyySWJR9f/fBhXGRsdCExyqe4exTadkeZN7hdY=;
	b=mORim/ijuAmpU9TiMWahgoIwS9UAZeoLjCNdAXXN/C8KE1VUmqyVubSa1Rhivqfk1KM8qp
	8qR3n6Oa6RXfIow+H5UWNjoq/4WO7kcZW7/+5PyLXpH8fhJZ3sw8txu7L55IXvjcolAdfZ
	SRSNG2RCsv0jzPql3R+LG7Hp1/okCYc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z6EfezPE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gvzOUx9N;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756727936; a=rsa-sha256;
	cv=pass;
	b=8TQieUTYfTDSNm49a60XTlNH+KJDeuXGEYwdlVUO0iTNjGCQRCnKuB++lfuhzH9H1b4btd
	njHza5ifLIpx50MwK/AV64JXBCSJvGxtSBTOiI7HFxKiwFPRV9ggxKfq03c1DM8E1dLZYW
	0S7pBKY4RIKrti+2ATqI24yJ5slOevo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5815fmIF026606;
	Mon, 1 Sep 2025 11:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VAQ8lDyySWJR9f/fBh
	XGRsdCExyqe4exTadkeZN7hdY=; b=Z6EfezPEs5BOk+0wp5XCB9SIDDYi8G5jsz
	A2P8sIlgJOibrubbFOA7wI34kieefVNWbZPpF3P1ioDr4nJ3c0jnZz054OwTbigl
	WsJmiOUrLEbdQw3WB6YEwsbksqTZLkvo5RIpFR6qvC4gzPKDIR+yzljYVlGvpRc+
	Y3aBfzt5ZL3M43ZmJ5b5s5ipiAnf4HQm6ehCSo3GEyu47AC4mxq8HlRYbmxMbW+A
	r4smpRtnz44G4JJpkaEsMJ2/hkVDvSHYMNL/PYcayy5Vv5OjDNahqm/aJ+YsuK5e
	W4U86KanW89cw0Hszk3EMDJ99OXXTF+1wcOkwAqMQ3cIuez91Y7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushgtak2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 11:58:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 581B1URi026871;
	Mon, 1 Sep 2025 11:58:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01maqrp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 11:58:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3R880YSrcBWsrYTb/NuPRMiy33bmZG91rrL/LjkxNsaYh6XVL44TiIakJlhbUAIrk+NDJE8u2kOBDpGvVbM5p3LDLtO4AT5Btxsj80J+LRmskAx0iStZeXirndInQubVGtWIRBbadd2ZdFZgaUjmF9O2aAHayLjEmIaEEN9mbqeRjbcDGzrDPnzgvzMFJ74OoJTNruKMfJhgLV2h0uuM4FhcQWn29+9KXCe6oZaSv4ndZsBV5fytPu+s3xCEeUozuriY6y84T9k82UgHQ/70EBiTm9uWa4NBKM0xAsHqYfxzAAh/7QV/yGfkEpRumFob0SPlr47MnlokzbyQb+h0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAQ8lDyySWJR9f/fBhXGRsdCExyqe4exTadkeZN7hdY=;
 b=serv4u/ewLEDS18Wg+FUfQ2FLKPQXkvAqYJAD1RsOBd+iGzRXIHnTQkUySvv+/pKK0Caa4NJNB7GKBn5UaJAfefsvtgAGhs7h/97KOKvvc7IAiAjd7wzPN4ySy+t+fkURD+/Qr0Sxq1bcXuS1OCE/NNgrOFMTj0CG3ivb/yDHAnEVD+bSJKQIMQWOUU82Gnq6N0UdNHQpK26V9yXflrfeEdlr/29BXqH8o0VBzG8IUKWhtR1BTYqEhSYoRDFapgp0RmgkyBAOCvqxEE8cmVMe5n0EXBOLPDXtGPu+pR9BGHWhdw7GX+O9ers2uAiNxRWBUOXBX7y91VK3LESgYcHIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAQ8lDyySWJR9f/fBhXGRsdCExyqe4exTadkeZN7hdY=;
 b=gvzOUx9NWp3RBUJGyYQSpnaCcAuXP0KwSy60sIZyV0+qnj6LkA4P8XRhTEoxlfdnKjpoY8bRjm+xc5xLtUunEpq9e8S16QvC9wqXW801ViaWVUGPK7M2VmwYoixO6Dxz/yo9cBqF9Z1mFurkl/ZsJqofQHkDj4/W4JQ5J3gzM6Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8732.namprd10.prod.outlook.com (2603:10b6:208:565::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 11:58:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Mon, 1 Sep 2025
 11:58:17 +0000
Date: Mon, 1 Sep 2025 12:58:15 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] task_stack.h: Clean-up stack_not_used()
 implementation
Message-ID: <735101de-5275-4a3f-9080-073d29c43882@lucifer.local>
References: <20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org>
 <20250829-fork-cleanups-for-dynstack-v1-2-3bbaadce1f00@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829-fork-cleanups-for-dynstack-v1-2-3bbaadce1f00@linaro.org>
X-ClientProxiedBy: LO2P265CA0362.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 11d24d58-417b-445d-9c90-08dde94ed6a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9Xj303M1JFfEv+ZweAFibGxhx1x5cFY1FxouwpFWiL8bVJBtA544x4rspf85?=
 =?us-ascii?Q?9QdUTli8qbinU+SxUQalVMug5x5c3jz0xBNH6NJWjgIfHWF/B6zDaU4PqlMC?=
 =?us-ascii?Q?PNoJvhLq/rg3W5OI3Dg0lBTTvIsSn/QrgCYJ/pw4oRk6YCEc0k5v3W6bdYbi?=
 =?us-ascii?Q?rNFB09Jw9FyPGAoEVc8eyk8PfFjpCKQUAUD1LPvccCtVMK+WvZiE87pr6zfR?=
 =?us-ascii?Q?c2amsblDupDjdPVkY7uhcSIn1W2nBaVcXFzTr2PgmuOrGnDsO9v/EhG2hc1g?=
 =?us-ascii?Q?KYy5x23pgYPo5aZDMsSmQL/uLbYcWpxebjJkjBqaxY+Dodh2oNjlR7JvGBEq?=
 =?us-ascii?Q?C3BNclY/J5Drs3ym8cuHDlUNRm5ZIvI6o3Opcbc1jWEGsM8LQYUxoEfmEiMO?=
 =?us-ascii?Q?U+oB4TcOuc93f66yyuS6l+axF5kuj2qC42eQi7jMmbaK+U1q4ytztC9nGYgb?=
 =?us-ascii?Q?3uyVw9F0fNerz8T3q+vdWr1Pt6b7Rii+0z80pxZYUHPy+fjH1Mpu0SHMGtd/?=
 =?us-ascii?Q?8YMF7JqaNx67OUGtncAE0FvY9+U3etbz0y2RJtm1ZbmCkiDfVT4R9AXu4vSq?=
 =?us-ascii?Q?BuvjycqSRlHN9rNGf7JWivE2X1DKM3h1P1ssCBWv+fpgO7x2cErqhhopXThI?=
 =?us-ascii?Q?sq2tODMOLoGSjPjsym9bKkNfSKJJmgL+HYe6WDDvLaDThB4NPym3+k1dRd64?=
 =?us-ascii?Q?/22BGYNQl6n1RXWzWCeM+Am94GzaMWhyWlIm90IO3p0cFqQ1OmIHBvJjEO72?=
 =?us-ascii?Q?PX5+8SaQ9fWS7mZaM3Umicvx2G05OAwandk01qomdhkfplHE5Uum8yVe0AVc?=
 =?us-ascii?Q?hTSNgf8QNKkfdwvpU/ZBW9yyYIswaQNaWqBQXbnwmvC0ymSDUuCisX03BWug?=
 =?us-ascii?Q?AROorRjsP13Q2Kj6rABMj4BsT1yqYDCDBVm5DGz3qFlVVYJP1PHTqojVbCz7?=
 =?us-ascii?Q?1tsLLP2FSGVdqO3ug67q9ff9rEX79wtM5S2uQaErq3cMf69VIev1AYN/b7RE?=
 =?us-ascii?Q?M3miWsyBGbPwEpdT0sQHKiuVDMP09xWLesoGmpBAGfGqNbLtTUZyEXofpUYA?=
 =?us-ascii?Q?Wy9ycBAqfMgJuChNdyA4k506PUPxvSfKMtWMQZNfpfaTmiOp/MzxMDrRvoAt?=
 =?us-ascii?Q?M3f/VwNT2xPIJ0TtEQ8zt2GRG2kXsJL7f0xiomBXraVqdnNvb9gn+XX+NWtn?=
 =?us-ascii?Q?mgQJFvPEJN8hvBq14YZ+dXtIjwaVOyb0pIdGrsIuuzBpJtkMg8jNaXxQA+Jg?=
 =?us-ascii?Q?3GoqYMwsG6Q8Qgkb7+rdTHbOV3R/vHxw/q7yHu2txDztJHMdN0qPukorSv/z?=
 =?us-ascii?Q?+QWRfJ5jnPvnfpdwsjkqEsgpC7VsSficO+F9mViVQR4qEPZYvB9bxFk0FuBN?=
 =?us-ascii?Q?QGu0A5tKy19ELHkQJCn+sSKTpOQb52PTazduXi2R+Lheas21/kefiWM8t+td?=
 =?us-ascii?Q?E7R5hTEzQ6g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5NDiUc4laxQUnpmGYrkbWqKhXODbRx5OYakGzLFsHdy1v8w97T3hk/w6YBNG?=
 =?us-ascii?Q?WcmhN34jL3tFyiBzrYIdi5GAYK51h0+MrKrqa/VE/Caf6Xb0bahSXqnHt5KM?=
 =?us-ascii?Q?exatPS+j0IOUajWXFSh8lHSSmkBU0BHQLz1L31GnJyXuoPrXr2YZEZO1Bdye?=
 =?us-ascii?Q?eLLTOnyBsHTFS4X3FYWESzp/Jd6Ae2uJRYY7Y0r9Bl9Z7pSG0R+MMotuWJze?=
 =?us-ascii?Q?DdPCbvk1WpzfjcGnlLoKRSl00qAoc/npSGlveo1fbEGkamkWOfaj9q0G1iwu?=
 =?us-ascii?Q?5jKuh3jQHM14XEweFRi8bFFGyuxrndDhZZfTVkz9gN62JE1kQDcyW97LYTh+?=
 =?us-ascii?Q?gIC+k5WinyrsqNptsYnc09FSwl0RfadqA7AgCAFRKsdAPV8z3BA3qzlW+x4a?=
 =?us-ascii?Q?L7R6YK+iqxlcNameat+0plD1GN1+U2oqiGZ1/8HQdAfPpdnNy1bMBqSlAZl0?=
 =?us-ascii?Q?/FHZo+vk6s6LeSgHSsQrxfOL7yPM4lHfq5Ln+c35Ly+UIe87SN8WDorX+k0e?=
 =?us-ascii?Q?29AJsqGZXtYhQqDMJ/NTpjnTQPJF2TuZPWFgyx5EvYo1w8adzui6UIB1ZQss?=
 =?us-ascii?Q?rNL7HAVVQImtB+0z3XdNd2mkxc9URnIpPHciJY14dVzBLC0s2Qb1G1oBd3pN?=
 =?us-ascii?Q?MYcSnMzf2HKCpNA5+FAX3smKWUD2uJlLdcpDTjk4axHZorWfsQhLt0oaD8DB?=
 =?us-ascii?Q?pFKEOz9gvj7LoGof+zrnCwcZfBdU0gH0XQsAYatrvWFmcMaq/z3PA58jY9do?=
 =?us-ascii?Q?Ok8gTx5O2RdgNEPCZM4JKSXSp+DDg/uvOFgytZuUv8wW73C1G8v1ZjZF6brX?=
 =?us-ascii?Q?xDbIS+rvc3npSUBg8S6j13hrN7Glebcmy8KPBxlwMrGn+Z1Rax/2SH1BZ4cW?=
 =?us-ascii?Q?xWENvH4XReca8MFIE4JGDCRdyxctRowkaJZ5T1lwegtNomWuEhGnpvOFBCWy?=
 =?us-ascii?Q?z8Pnb4tlvzX6IMstoJdi57EJ82766joj2NJ6eMEV2iOXxhk4w+PnFOy7Y8Al?=
 =?us-ascii?Q?Y+N/aRNrbrwSG07uesORJnaG/9yEhB0E08Y71w2pMVy9aYQUNIbiiYNXNxGd?=
 =?us-ascii?Q?9DQrSk7HLtjx8lr9Sv0lZJoV+aKph3KKPvQjp4x/iR5QwsDqQ8pjpE1/ypzw?=
 =?us-ascii?Q?WaOePX/HvFSI+nbB6M2469l+aKk2TqbtW9o9DwXBeE8XkAvafZeLurNa8U2W?=
 =?us-ascii?Q?hbWFyMlncWx8CccHykPN3cmbXcu8azyPG/I+TcG0vxDUrgiEI2YZMqvTa+XJ?=
 =?us-ascii?Q?x2Uon1baSSow/OitDcQcNFXcZqvfy+0AefeSDP29lm8fRLw6niWQyr49QpRE?=
 =?us-ascii?Q?y0+ECuNzosNU+Hi6p5CXZMzBdu1LpFThZ3ZproX87LBaicWxXWr5k7Zt0hn4?=
 =?us-ascii?Q?5ZyGl7QGBRs+NXCX7wtllygS5cCPFXsDc4hECPGB8f3rfsJ+sk9dFDX1GH8j?=
 =?us-ascii?Q?waYlBJtro3NqiHciHABwWQM1F9bzthM+5U+6GhDcGZgiHPstKx34RTHMRm5+?=
 =?us-ascii?Q?nTPBnoZoQMpDX+L66KHxAJ7qiOeRvcxyN8ivwuT7d+th176Fr+7ZOHN/8pqP?=
 =?us-ascii?Q?fErhBpG8lq/yNbs3aDXxwvMf5V2jDYpg2X3HLGLWVOWwn19uxFvFHlmTqS35?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DDugyCCYf5DGUiaPTGV1WlULEwmyxGMtBd40Hgqj1EKmyNRG1xZ9U++hCvvwk/HnSAgW7VXi5myAAmhHZ1FkTGOaxEllP4AOSmqvNMSvB06E1rGqxmf8viYnOC9Eqt1ZIv9ErweY7vh7gWYaIF3SOFq8MSPTWVEAlUL9OVljLou45oTa6gIO61y0jxHnRMl6MzHeGxb+MTW9rpB8bS6wFAIJcv16GZLKt7591IEnFcM60M6cvkgpcmSo8dtjU2uOqOQtMOzvdQOLx0eL+C3lgBZO2Xqk5FlBymUSf8zGNkvd4bZNRju9UsX3TSvL6X6mwk5x+ZKak34Kc+H8QZVbtody2YIllSm/Sz2VaADYfD9Cty4CiVFMrLrJiYgsWWGuQJg3J0RNFTHweCk56rj9OEu9M6QTggc4jrVkkSh8DmguRC7GzjQwqf5EjX9x2Km9gbbVP+sKDNMSlDLEjvVrwo5iMeCnnyJFHBYhx5I6x6wtT7K0tD6jUgjpPLULZR1lV0CtIiHDKV65HFbgFdCVskN3y+2eEKczDuLuRJ4SIt/Q0ITlDPyrChbdfcKRfIzGSlWzgnpLQ6NO57hiHz9OFi0HZL+40qquFMn0CPO20hU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d24d58-417b-445d-9c90-08dde94ed6a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 11:58:17.4663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lqgfmzcFn87SxxURJS6vRBQlaQqiuW7RhgqWJzckjdB3wYpblCPrdQjCpnX2dlKh0C1CFGISuOICgpsuuu2+LHjFK25FXrXIyqNBUT+OEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509010128
X-Proofpoint-ORIG-GUID: L6ktgNm3BvwaPfX65kLorw-ROJmwKr0v
X-Authority-Analysis: v=2.4 cv=YKifyQGx c=1 sm=1 tr=0 ts=68b58a5f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7ipKWUHlAAAA:8
 a=KKAkSRfTAAAA:8 a=yPCof4ZbAAAA:8 a=-qKUV0opkMw2jbiCCzoA:9 a=CjuIK1q_8ugA:10
 a=gpc5p9EgBqZVLdJeV_V1:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX5xTq+ElvPHg/
 yQzjocWyXLqEAbrpbrHnU2Qmv7Vz95nMDnJxn8jYwnNtUs9I6ec35uly5ctnA3cDBMYVK1jFQKA
 1VnROQ1z7mw4uitBq+UAqDDFUPKMzsGcALw1Hbz5tEHnEcNmcKZFHpsMkNRY9qfId3FRDXnd+NR
 Y5ufsVgF3PVn6fa3rotS91tktSz3Z6c1B9hgri5SJhRwuJGcbiDrwbfjtTZxe1cG82YgbQ5cgS4
 uOlE9b5qILefselCnLqxpA+0wNIsmfpBVWfUHFXg6ssQTFnrURBXihGvnp4in5YqLSZP6b6T6xa
 VT1N0ZT1U05LkJzM4zBYE14xPIYsVb5aIiALeYfqhZK6V8lvmGVrfdvCm+0s1aFiJkiAOyDb/VU
 6wWXvZTx
X-Proofpoint-GUID: L6ktgNm3BvwaPfX65kLorw-ROJmwKr0v
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5DA78180010
X-Stat-Signature: 1szsxqca1oeyc4ifg38g7d8appoxux4h
X-Rspam-User: 
X-HE-Tag: 1756727936-370722
X-HE-Meta: U2FsdGVkX1+KBgmIxX5s04G/DJ/sRMIx+oMTWW4/OV0LrqFh+a0tAO3IYeL3qrIF2I2epbT5dLWXC8XJ6/FkhM9KF1N28IX6kUpfGjtkZJW4zN51KC8qq1Kn/fInf9duRvLAyyZPhcmWKDWv9SOITz/ZMOZsXCNKlgH956OVoOcRFcmRj7++/v3KQU+nkbM5QW6mk9CEHrPF6CI4g9fCh3eS4THKWA9yVbsYjfzh9XnQgvOf7MuYoufv6kCEdIoHJa9Pv762+0Hex9p6NvLqTgDzcejdiOUFCXem02gEpSp/LKIJiYfy7se6Ikwimy3qemfO8m8q9rVTNdONQJyv3XkPf0fWJMgrhnAdiYD6e68kxH2wuJhjcYtC7744Fjve9Hr10BeI+KOTLTuHUj3mXTNTsetdub1de+ejN0N6vM9xeQBs9EyadSysb9fKoK/EBvHM6n3x6QiXMEMq2k0jlROfq+HqOmZMwrwnXVVtsajSOXLZzsCA5pEiBXL5A7wDueDg2DSX+fNO3z2/JyDvD/UM+OrSOUszah1IV75NKBKYJFf2fExv/WkCwia1zRKMDiu3yatzbyqeApfZwvbvuJ4uIcr4mekt0vlqv71YrBhXevlh9wRZ0w/YW0uOv01o2+5rZHotHKL4pb6JN18sDGKvSV/ZSeegaREOlQpKsRyAofZSc2bE/5zbBZy9v4USlZKY4DRc7qC1n0nBUIQ+tWj/9QI5IC2YLMx9bYz0pG+kxKF+ixxUdC6ddbRLWzyAPcckqOCYadPuzXJMFBYe+JxR0Sm9EaAMN/3dDG3STFaPS+hzKqvaBMjO1ChRlPSaaV3V21eMcB8A/jwryDw2aW1siwf7bOWd79LY7qQX41cFjJ0ePYm+lZzGbdP97zvCQVdYulDNtLxSKLibV7ri5jWd30PZHF1niWrA4NBaSTRq9XdqMHiLU8NBymLcjr1g5WVLGiQEZiYCbKavXqu
 6Wqmk+rx
 4JsGDYZPP1NyoKixIRGUENQc5Mh6rZ2TK4qnCSNai+rDBWoWafj3BkT9dw8p26GNKNk2/p/kC7SoEDAgFX2I27cSAAnxB5HQUcB82LiCWH6tnwxaFdqtFLvNTIuUsOgkkQfEwCr2fvSauu9NTQBOCUYBPSta78j6JBpBsPNkVXDlG8vUDdNZXFXWztfcEBf6gSDLX5lCIJh4cegI99CqdVIHqayGJUFp7i85V0+2T2QkYbgO8Ehm/IRF8Jb+gWmHU4iHGPQ4563DLE9G+bfzSd5ICTF/YZoteXKTQ7ro90ggWDv7LQ6br0KO0vIBsKZb6Qvxa/CLMFdxGN0HhGnE6QqqhBM8lhdxCa+mns163iCciMUlZfTPem/eluqvB4SZncQQsCatDRRYJAWmfmVSjC1xUdCD332Taf0/L1lmsv+PDMrxMjPFxp+BQex8+R86UAURyRtqcgXtrMDBl4BzTRlOXRKw5ETLaDIpvZ3+ItBKoEjJqUWcfJSG33IgJGzLQxytUrr67vh1j432pqiu3wo/3SLdMR9q3KRVFq6dF+ch+PR3Pqvq0+R9fa1ZxT3Y1Yjy0eaRRaX9vW9tNtVhE2ouNXr1deVdZnUsl+K3KtkR0ZvEJATTzGEwOBZOW15sngIkh5I+i4OaMiIUZbIzHICu5wAqfwD+bUt5BAoKkvoGZX+Lm0ead1jVXfO1E0vrWhtEYNfU6YSlvD5C5OMixCnY+NglmwasrXEVgpFi8KjM9AI2TYTsZx21OZRoZ0LCxsf/tL7YpIu8tIB3CgHuGtvg4rqX9tDGqwgkduIxnqzWOjrR4+lP0ze1YJSHoVnes4Brfkfk0ZQREjOOje+nWpfFszPDTN5MQYWw/7CpK2lvMFpYOYh1IQp3/tnts0rspJoNfryY9gEkOUfUy+rUBUvooq5eXIbWvOrcgCQ3ht51Jtsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 01:44:41PM +0200, Linus Walleij wrote:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Inside the small stack_not_used() function there are several ifdefs for
> stack growing-up vs. regular versions. Instead just implement this
> function two times, one for growing-up and another regular.
>
> Add comments like /* !CONFIG_DEBUG_STACK_USAGE */ to clarify what the
> ifdefs are doing.
>
> [linus.walleij@linaro.org: Rebased, function moved elsewhere in the kernel]
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://lore.kernel.org/20240311164638.2015063-13-pasha.tatashin@soleen.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

LGTM, lovely change! :)

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  kernel/exit.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 343eb97543d568baeb23142edcc9050a8b8be8bf..9f74e8f1c431b6aa6e391ff71aadf9895a3857ae 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -780,24 +780,29 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>  }
>
>  #ifdef CONFIG_DEBUG_STACK_USAGE
> +#ifdef CONFIG_STACK_GROWSUP
>  unsigned long stack_not_used(struct task_struct *p)
>  {
>  	unsigned long *n = end_of_stack(p);
>
>  	do {	/* Skip over canary */
> -# ifdef CONFIG_STACK_GROWSUP
>  		n--;
> -# else
> -		n++;
> -# endif
>  	} while (!*n);
>
> -# ifdef CONFIG_STACK_GROWSUP
>  	return (unsigned long)end_of_stack(p) - (unsigned long)n;
> -# else
> +}
> +#else /* !CONFIG_STACK_GROWSUP */
> +unsigned long stack_not_used(struct task_struct *p)
> +{
> +	unsigned long *n = end_of_stack(p);
> +
> +	do {	/* Skip over canary */
> +		n++;
> +	} while (!*n);
> +
>  	return (unsigned long)n - (unsigned long)end_of_stack(p);
> -# endif
>  }
> +#endif /* CONFIG_STACK_GROWSUP */
>
>  /* Count the maximum pages reached in kernel stacks */
>  static inline void kstack_histogram(unsigned long used_stack)
> @@ -856,9 +861,9 @@ static void check_stack_usage(void)
>  	}
>  	spin_unlock(&low_water_lock);
>  }
> -#else
> +#else /* !CONFIG_DEBUG_STACK_USAGE */
>  static inline void check_stack_usage(void) {}
> -#endif
> +#endif /* CONFIG_DEBUG_STACK_USAGE */
>
>  static void synchronize_group_exit(struct task_struct *tsk, long code)
>  {
>
> --
> 2.50.1
>

