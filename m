Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4CDCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 05:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0250F8E0003; Tue, 11 Nov 2025 00:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18028E0002; Tue, 11 Nov 2025 00:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB81C8E0003; Tue, 11 Nov 2025 00:21:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CACF88E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:21:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EE181A03BF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:21:29 +0000 (UTC)
X-FDA: 84097178298.22.4218EC3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 01EF340009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:21:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nz0uZ+qM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Rc/c12gZ";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762838486; a=rsa-sha256;
	cv=pass;
	b=rBiZKpJtS/F/xwlYGGhGG4OGZ97mzI7hRQZbcUkzquz8kbNuThOTHr/egsx1bQfTcnr8Uz
	aTzcgj7+B2UXX2X/hPQLcZ5K3eZooq2ayl14G84ZfzYFAax7w7OHoBMi0Jwcxn0OxAltd9
	YvfDd1v258G+MA3hLihGEUNMHPUN0mk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nz0uZ+qM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Rc/c12gZ";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762838486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQkp5QfWzBb8d2tL4TnKbVMTZHfIFh4Fw9kVu3f2Jpo=;
	b=qYGYIHOU1141b7T6/Kkgy11TFXKOleRnz6fsUApRpPyTbb/WSgMr7inYlVEt/BXFe2x96x
	tHYVjEGyfIO6CNMhjNoT6Lr7f2zqM3FNVxzGF/uHRroKYWBuA8pinO1RXsWMotLNR4KEmT
	qumfNVEzMnmfpGJGrIWmNmm8hNOFuQQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB4t2AW029069;
	Tue, 11 Nov 2025 05:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jQkp5QfWzBb8d2tL4T
	nKbVMTZHfIFh4Fw9kVu3f2Jpo=; b=nz0uZ+qMP1j6bZCGb2KmthPzla0z7p6JD7
	rp8GScgq8dF1A6dt8oTtuJRNvXko62i19yNC5IbqMfpE3rgoSvCcySWAScQf2TWd
	EzqzWlYk0C22HA4fbA4zEgIf1p/vDKVYQDe5YAPT55al3/H6c6MxRSqy8+mm1iJ5
	82C3ZoOM7UsMu0lng85vssAHWgF+WZPz0jywwMnmABFas444f4FFTCX63gtyGXXg
	baQsEitq2sqvbRk9HgWbY7KJ2/qkuukDo4Bekt1Q5pdd5IpRMnP9RdxgVg41PwKN
	xQSTWUybGbbwSTlemIplmHIUJQAPj3UxG2YShkY+wGKeFnuq+L3w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abxhqg1hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 05:21:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB2Ca9r040864;
	Tue, 11 Nov 2025 05:21:21 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va92f9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 05:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4imBGngwpMGEEDnZ92cQb+kjDqM7V0K14Cy4rCoHhUhgsk498pCzyBsDPJ7hcdDUT0+AZ5ToaOg47Ie7FyfTbwOw9lXMK3Bm9AnHnZ+QP3evwRrbi0wlpp25qT/ETzmMFtaCOIv8d/FMyKGdsABA39IObAJlfpPtIuu+6q6x2hBdoFjWX2HoLKNZFWKTj3HWgNMD3p8otvprOJPHlAocM9HnMsQgJ6SEpiBtYRL+BlIj4GAlfauD/TUGOSc8tgBHrVqF/Z5TlP9hJvTGPs4xIv57H9RkSHI/kEbpNCDy8I4OPRyNiJ0BeJ8vr+Drlq7ewk22tvpmnrR6U1ceQMiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQkp5QfWzBb8d2tL4TnKbVMTZHfIFh4Fw9kVu3f2Jpo=;
 b=htb6m7PgWV/lRCP5yRIPE4R0CqKbbb8+QV8MM5+pDzqQ99TjU7U/IQHcfu8oqwsICb2hHmDH/QdJWV0mnZlINtjVb+nkHtB1mDC1uInZQc4yKoGSsOHUshOdQzFev+T0JIaOjllF0tKS3sjuVbTVDYpfC3hIgFOZ4jsLriufAJGZakBtfZLUCy9gCTkk+ECNHNN2PeP0057OgYEUd3kwymx5N/jJA1tzliq0Wkttg0c52zdmQKIGJsjjykFXvF6WbpG89S4OZAewRPe9nhiiy/C81k358yvao9SKfS8eQYD3Tr6DZ4+iA2VD2+Eo17WJkhYCGUpwgYnJbPSBHLTlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQkp5QfWzBb8d2tL4TnKbVMTZHfIFh4Fw9kVu3f2Jpo=;
 b=Rc/c12gZ81ZZ/EZ7hK3HlilvMydHHQB9biQtxmzeKaZz/sTnspIU24G9nBngFrROU7G9mvpjHd8cRaX+gt5TftjZrRLs7bh3uBHtj6Is88tsPqJqrlxTei7N6+k44CHMGdJX+MhD6uvsn+BIBjCq+lSjJsN8KT0afOL57EpLghM=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 IA1PR10MB8210.namprd10.prod.outlook.com (2603:10b6:208:463::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Tue, 11 Nov
 2025 05:21:18 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 05:21:18 +0000
Date: Tue, 11 Nov 2025 14:21:09 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 3/4] memcg: remove __mod_lruvec_state
Message-ID: <aRLHxZo1K7damagn@hyeyoo>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-4-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110232008.1352063-4-shakeel.butt@linux.dev>
X-ClientProxiedBy: SE2P216CA0053.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|IA1PR10MB8210:EE_
X-MS-Office365-Filtering-Correlation-Id: d506ded3-81b1-4c7d-ac73-08de20e223ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NoT1yDdcUQfO9PIODwF0v6ju+xaMq62MQq0kgwT6Mqb8QNHtgfF6F2Y53YAI?=
 =?us-ascii?Q?H66+joC/PgnTeCEAl+sbphfW0bMdAUwj8mtUH2kK4e+XJersiRoKbP5UQ8SV?=
 =?us-ascii?Q?O8S//mbhbHu+IKSNxY/62sH4iJaY/tCUfUhzWrYyCcQAW5Cts1vcGum7FZ6T?=
 =?us-ascii?Q?xFklxawhRt0F1jdQT1+d0N6QVqgXAlMmxDhWEdXeBf0EAYuoZGOHnqWGU3jR?=
 =?us-ascii?Q?dA7BB8Fk50bRhkntm2jpL9IkC1DDLxbVdG/ZOPUNPYWIqfo/5f5xR0ykSfyE?=
 =?us-ascii?Q?Gh1/pUBBqui4O3PtVTPdFVjSjCJwqp/1VDiW5bmTsTu1fYJ6tdHRDg6mii+M?=
 =?us-ascii?Q?17FXY7nrDSvAMaOa8XX3p2n17UDnfIUy6fw/skfQY3ZRzwhO8xVpFTV0t5/X?=
 =?us-ascii?Q?txwtpAspZ9aw/ErQSXRTq7bUaUATazmK8MoLprWUuN3R2eXl3w0O+9N7sPK6?=
 =?us-ascii?Q?EKmjeJ0KoITnReWFBta5XUaRJkMaahBoD4fTEHcDoLPqauKAvQcL0X5oLitD?=
 =?us-ascii?Q?48TqNDW/SbX05tJvvuFN5nImSQ9mTD+KZ3RbmhsHnNy6GQ3CBcb9F65ELklN?=
 =?us-ascii?Q?lvzJcy6GrdfcwHnr7blcsa7ZI3MGJva6uXkk0jdrevkY+4SFftjYlpb9EUPh?=
 =?us-ascii?Q?U6dd2ovyCx4XVW4boXhak2H36hIyBZOn8F3jvpLrVEzA4P2wyi43QgyG86U/?=
 =?us-ascii?Q?ABaKlv+Mhqs6KbjxJCf8WywliSy5jC5oDG1Y9wBoXvfthv4nLC9AuF8/9DRG?=
 =?us-ascii?Q?SWlClCYhJcLDPipKtq9+KVF+WMmJOReQaoLScrLtJ4qSEqHGdtmJqyh59SQR?=
 =?us-ascii?Q?MY5mz66W18Yzcn5S0VNf8j52k3hzuc93r9YI6nJBz70tT1Kyj5cGLDtP03kf?=
 =?us-ascii?Q?5RTHJ0fy8XHpYtEm4Wf32SP5RnJlBrlVH5HUnCtlbwnI+67r5Dj1BHk5EBTD?=
 =?us-ascii?Q?dF3fJ/BIsOWIz8W0XCXWAEn9Q9DdarghJzLaQTwOb8wxKwy6Jojr1R5vS5wb?=
 =?us-ascii?Q?8qDJvyeaWH1Gh72HfpzxsfSXwshmYhNQCpRYnz88JNirnzAQVffrgWsUczZY?=
 =?us-ascii?Q?qx5SY8YGHwiJaYtOUNS40VlykPNK/h8AXHF27y15nPrMwPBz2sjouQF/iojd?=
 =?us-ascii?Q?MnQJBU5ne8P6Pu1qqTJbwd1R4Q8eitRRJLUT1PkrZ8/y+D12ZLXBpZHlTSYn?=
 =?us-ascii?Q?Dg+boUakIXb1VQqQnYGv5h2n8iZMOxuEEFrRcQN1UQ4IIm7+GAseGU8RwheT?=
 =?us-ascii?Q?Uz0m/bhuIyi9jrA/EfixoiD5d4njzPNuaj9m8d+0vFn9d7neLbH9ugjA8Okz?=
 =?us-ascii?Q?ly7fKMasrI7WewOntC3sfCO7fXGExvbtfimJTs09sp9UyJdq9TZ9CtrLxd20?=
 =?us-ascii?Q?6skAjGiQr3dfE70m88w9+UBW/HIrxi9JsAmgHj/wqHgEdZQIn7SL4wonXUP9?=
 =?us-ascii?Q?pJUY8Zd3q69qMvlMOop0YYBpbGKnkphP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aWXnK35gPPwXv7HdG348MHk76YvWFq6NnAbWFD4AVRgXJfW4fVilMIpISbsI?=
 =?us-ascii?Q?qPFEbA3d3pzNgO1QUicsUoT++uS/00tiDsQoQNM25NZWtr4/5i0yLLbsGlw3?=
 =?us-ascii?Q?6HZ2BTeNs7Nz9ZYNl3Ngqkv4MZGKi3PSRvxiKO5EZOEegl5dOPfLXuUk+R5Q?=
 =?us-ascii?Q?u2bRhkryKp42g0kc8jr1dTIMmQJp1fU1H+tYDLegRwPe2zJAE+lkK+MP7rx8?=
 =?us-ascii?Q?+npMaRYIrY1zcApaBQQCXSO5DPge+bZ19zlZO373t/rGrXqif9JxMpYvFwkD?=
 =?us-ascii?Q?Hbz0NPax0TRnvsDd/z5QRxMEuEci09Fvzg0dRy6Anp0FsFdfsjRIGLi96Pih?=
 =?us-ascii?Q?t6XooZBLfr7eY31MO4DmqbWiY1uBidTDDOj3ApyNjUBa89MsTr/4sb+lZIXO?=
 =?us-ascii?Q?3oAv77t7XdKFYAuZeCBNWvDhEFvhCspe7It2H/hOigEZckqtEX27UR/oW0oz?=
 =?us-ascii?Q?J58k/imSECa9b0MmJwOcBTS5sG0lsPAVMsQKMMBGwPqLYV8JnCiKBreFSYxE?=
 =?us-ascii?Q?H4YSCcIT/OaT68etI7Ql1/MqDtVFszsqhavFZIPIFHeqzMWjdh899OloCo5/?=
 =?us-ascii?Q?w3xQWN+ul2fQXaQqybIco3F1/XfEFfPxnAo2n1n7c66c1Mee5NCZbqTF6h2r?=
 =?us-ascii?Q?yH3Jr5+lZQ8z9njFF+JCOQLTFoIIWYQicwVjP/Vqp1L18xKielfnKmRk4b6K?=
 =?us-ascii?Q?Yn3x0IZwhjoJ7jqhU3qPI5a66T7jWAaT8AOZk5xI4u54Hre3KDnxdpqGJ8+h?=
 =?us-ascii?Q?1ga1Qq06TNaiKtCCe7a82FxQ1QmC78PyrbS3LGcP1wOBKS1gx+4IUvLMF2+5?=
 =?us-ascii?Q?oiRzg36R24Ga/NriCwrsATyUMdM1tk2tr/ZkyctB9VKKNT5B1mzqOQCYAnor?=
 =?us-ascii?Q?wzs5TsoeFBfx4XJehR5KCBABKsg4jbsqSm79d1R15AZzpK6JhxTa4Q7gZbry?=
 =?us-ascii?Q?k44gzgo0RkT/Pju0TUBOUqW6o1FC+5OEzTohPt6JhFXk2glWmMvLovRBRZZg?=
 =?us-ascii?Q?Wbn6jrF1VgKvbTFltt4XFSTiSm4YZX3Hg2Vmwc5P8TimXzcoiGpQ67YQooWZ?=
 =?us-ascii?Q?hXI+e5l3iPRx9pZVEq1H/8BWcomnXS3Z/7oLdH+MJ7KwF8hdOqtDynGylI2N?=
 =?us-ascii?Q?l8ZAwVXBCJ5TbgouBEcQyg7JVQstN5WmbSfYEx6wDe4qEFJJT+uB/LAQ5P3s?=
 =?us-ascii?Q?7WRalKn2MqbmOurqeWyGIX1DBp3Nk2LIjTbpxsLw+MIJzsp8W7VTeE9Pnigm?=
 =?us-ascii?Q?1bxPDJ+vX6PtF1m9p0AZ2OMpqgtO5mKyrVj0fLSOcHN6p9lcOIaAXCH3xnrB?=
 =?us-ascii?Q?Yu2iD6ylqdvi9BCOS1xB2E0SuOBXAnr6vMPqqkKhkgWkvDBlajc8i5k+go+r?=
 =?us-ascii?Q?DqeuS2Y52tMgOB3PaWvnEnF4PMNJEi+MHHvW4loq9tHp+HM13VrKehPfbgBi?=
 =?us-ascii?Q?n7jJFIV0xoHVhd5rZoHUaTxHrCNozLW2imPlEDF5fgpvqfSrYHeT8fUcR+a6?=
 =?us-ascii?Q?dr0cqDAJI9SIC/ouVoHshPBGz6hemS3bPWmkqXMWh8spQnVFlIxGeb465A+l?=
 =?us-ascii?Q?0I4eSnuA5KlC3GTbes8kB9FciNK1RiHfNyOj3HXt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	687HQAX9dP8wVgkrOiPmdqiFXiAsLex3js8OMYTNoaNoha6X5Z3GZDs6o2Bg4cC1ZAKYLbG5ArunpulWVCJ0xLimbIGSVWZfXdD1PDQGBOayTmFP8O1tAxtzqDCXHZcqYxByMsGLumVBZtUTevZK9PvMHhFhPEaoDcDmDSbu7sHCt5v7NUtr+rzUu8zf0JKSqCAN1igwsruNI9n7K07LV34qwco0a+tyeXav8Of3y/Eo+0ioh15+ZVyQ2zBBR6rdu1fhw47EHNAWmYqsSp00NlVyLFAf5lihaXbO4RYkHWkPe0nv1pBhzY80W5XUGRj5XcZwC3EddwI6OL3J3kk7f5zsNrE/12C5nq1Jwy7qY8EW4LpjOkYueYnTJNwq54DP51dZ0XKJTmSip0s6RZAcyc6NvDDh1T+4Ix9iCHEbrFRt/i5RVj62icsUZGpEwFBG+7zztLcb1JhO/O4GDxmoAwHaxrbcfKea7miOJkHggPKqN5+lJ5YyMTGczZiq4q4+DXI3/QpfqYw55XKHg8LLMw/Ibb7KiqDVV91X/6G6D1elmBBmkRALWCh3am4BgEUKGuaya9r+93zncUhIIOe/R1nzVFKRGMZz8zgvik1a130=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d506ded3-81b1-4c7d-ac73-08de20e223ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:21:18.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPEF/wIgNIkvq3KI64DYSsfvFGMfO87ZlBrvXRO/wfaeRVNKZiXvyRE0qNmr857+DdykPyGIdaP8yH/hhJXmWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB8210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511110038
X-Authority-Analysis: v=2.4 cv=VPPQXtPX c=1 sm=1 tr=0 ts=6912c7d2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=s2KlgTw7U1jQNQ_BAaEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: m2l7H4oGqZ8sxwryzXHM8LbTcA_puDkr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAzNSBTYWx0ZWRfXzMUuUGIIFPsg
 NGvqLEbrWQkCgFtQnvH0OeK6gwDChZk2dNvMIePbk5bu1epRYLZPw1SGKR6AImR01W2j0CUpFF1
 xI39130I+s8O7we7gANttuj1CybkoH8n4VMyu1XWHP6Y4q9pGZnHQAHPB96Y44PIcMlwaNcOz8E
 7EI/MUGRK4vBF9UOYihp2SSiCKf4UCvDO7JXy0l0zFlfd9f1+tLPSbuCVxLoSXDSm92uz1zc5UZ
 XhuPfVh+btSoMzHS47imnQYPeRYSZEGdbxnWYEd8FUk/IVjVhnhAXZFJLlKJaLlT4042nh8l3wv
 jJ0KcMpeibJEgeRyQl05v06dhY0S5O4WWXST4Eoxeu44jBwQoqD6VFu+4zc6zZli9nxUb4stuOs
 c0SGOSaZhBlGtV0ujZWxf4ATsQgzkA==
X-Proofpoint-GUID: m2l7H4oGqZ8sxwryzXHM8LbTcA_puDkr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01EF340009
X-Stat-Signature: q5gmpu7yzw5gizzo3h46q4ae1j1ymph7
X-HE-Tag: 1762838485-925802
X-HE-Meta: U2FsdGVkX1+VsL+cnWFOy5r4HloCJdyCxgU1fbARQL5eFssRXc09dXiAsDFI0al1/FU79xwCKEJbY4cRsH8pCjUM68f0hmcj0CCEDm8ibV1RDk1392sAYmitoPu1+DPn57Mhs45U5F9pF3CKbILybtRisKTJWSy5XWlmemu/0ivCxU3MpsLsGebzIms34QZ/PVZtS7sQ5N4Xg4yFHXDsDrOeaT261syhb8XzJLhZQOGioHoJqlC5KOhlspt4invqO/CDg4HSu9E6kP5exppPs/ClTwpQQDhJDypvaqCJGdMgniax+aWDqlfcIioffyYrGFYvfvTTWiY1Mb5Oe4r6gp6drOzDqj1EEuFokznRplCABqyuUtx5lqiN4sdnxzH8UUSmIYYC03Xx4Dlk8UDzYilR8lyr4G9bb6NaQajodQ8QRU/QkNemv316MpXfAQWUhcfR8L3mzSNG9zOUKQkcbHIaCkzdhIhrHasaLfdGpp1AzQXAfNgCz27JIsLfKkrHOTHbx7wq1yyHBnA7DdRbKb2QMydvZt69cGcIly+TG56WOaKOlU0PoIcGoYfVVoyU7MICeP+qqZGZXqmeXFsCDyl7oTu2vlCiTiLsBV+fkWW7vn738Exm44/SeN2axuCWxDMIJ8zVLesO4x7/ZrWT+SXH5G7PP4CQSJJVTd108teEI4VBb0SfhTKDQIJoqYqbtuXn3qRtafcMxKTYKzHxWGbK05UCT8Ue8yEK/V7R3ZotXppcVrF1fsEiX/7Kxy2ZIuIxdoGH1jEVsC5JsTgniyEUAZTTg7mJT8jTB5R3iEsU+KjwcaK/YjhUKu99ky8gKrU9ao3GI8QRiTAj272F3xqAFO79estXKbXeB6jlHIZL12W5iQ13wIhM5COFJY/nxU+XlzB6iAjdmj3WzUwq6Z2rhMCtmjxjnh1C0xdd5VRx1XuV3Y5/p5awGYODDpXCxiGZD+NhKyjEV2Eb/nS
 9hvaF4Ze
 XISG3JtbDRCAHa6pRmMAlFz605x7i4an/B/Kfpb1E/07rYhLLMZbyJl5uMkcabTfs+q+kH8WfCbPaBJdLELLjHi5MTCFa5sX7Px+vpHB2sZzWQ+fA7nlmHDiIuhgqokUJ9Fod60tNlXk/WLzKhMlGlzpmcIq0tkpF3k2Uj+ySQYbmUb5Qo9UdB33AnGynVJuFcaSFunvbsjI2wQv07hJXMjuhLUEOB36GXwNhvGygzeHH7FGUp1UZ/0YYSjQXWW+YgmpAifm5hq75I8z3H0zVYMFFzBwXO5xB0QYNe3AJnAxe1ttulx1xzCTBYsgSHgkH+dhsGur3Rn56nwsVYYxpoCL1d3akR7MHdherlZfef7kRl+Ewv27FEzZEsWwKFOPJb6LiMlgkBdAOeTjO7RpBoXb00+Ut0r30jwWEJsnKhPey/ApxVWQ68we9Ji6iRu6uTwmnDQz9mPTyZ0U8d23Tcf4ldrCS8+TU8ifIFYrBp9LH1MCjrWpmm4af2FcG53mDDGrOPha27MocQKe5zB8MY9oaxRY1srEn/6j8imnl0s4NwqUTkHQYkZrDCQRC3+JxZTV9olLJqof8Yht9JqVoPR1c/GRLnQXMgoIwuekKPugHO2/VzS1lHGtHJOYg2ChAEU9J3OiJWMIm97mcR+Wj8DtLdTRwsMhLjWS6g8Sp7Ni5LurKogItsZPYQZoUYj720eWalQHCf0a5djtVL3Jr3fRoMgyMW0DUa2rz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 03:20:07PM -0800, Shakeel Butt wrote:
> The __mod_lruvec_state is already safe against irqs, so there is no
> need to have a separate interface (i.e. mod_lruvec_state) which
> wraps calls to it with irq disabling and reenabling. Let's rename
> __mod_lruvec_state to mod_lruvec_state.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

