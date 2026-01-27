Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A9A0D2D8E3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45D56B0089; Tue, 27 Jan 2026 05:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D7B6B008A; Tue, 27 Jan 2026 05:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB916B008C; Tue, 27 Jan 2026 05:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEEB6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:32:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A6FB5BB14
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:23 +0000 (UTC)
X-FDA: 84377379366.05.E745971
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id DDAB6140003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NJDGk+Pv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JesJ5De4;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvigPEtAeS/J6qDiaRCpXtByy1AJ4rXQ82hr/ls2EbE=;
	b=Pvf0UwmjRAai1eURJZHNfSPu5WVXXIgSiD6CLETAIqq3YnHaXIj5LMdOba3grJo0B3vvpy
	p/7IN82VwsaKHG1wkC3vbVc5NIJOfg/EePAIRobffCWYJ3N6ajlI0fiyxLEw38JSkp+25a
	q2i6BKdUT5RXmhniuhRY25q9fvxKZRo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NJDGk+Pv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JesJ5De4;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769509940; a=rsa-sha256;
	cv=pass;
	b=8N99cnQ2aaG69MzjkRB9kRGr/cDtyYqpJX0flHkGpzFzQarXdFkkN6sPlW+sDVKNxdu5wx
	Au8gJzt0QvV12BfCN6xCYKKqkZnFQyCWrid5GhbP8E1fvdy1Y2/y4nHvoKZv2V9nTryt3a
	MYC6SqCkSe+Bv3RTw3YUY6wc9XUm1D8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R27VN7810594;
	Tue, 27 Jan 2026 10:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wvigPEtAeS/J6qDiaRCpXtByy1AJ4rXQ82hr/ls2EbE=; b=
	NJDGk+PvF/cQWUf27L+a5+lBbl+CRrT+FwqKl2eKi2Eh5y6wvekbF3stEVfxj7V/
	h4skRdk9LH6exz4yMSV9m6GFMi0Nd5AvE1pDhnmyUttCLHTbomBV+jgyXBb/TTG/
	nnkuBNGBD5D2AO8E55f26Pm6GTh2KjGbBrdy93LrPrXHxOav3EHElVb4TqHKg+H/
	hsE3iGhpgP1fd+VU4rjstMnuIvn2dI7VZPTV8janX4luIsE4rvtB53BsTBbyac9W
	3PmwhiQ7GOVCB103Mzk/+4bD+SufC9zTqNQA51fOkhV3NKwjt0BOzVX5nZ730tr/
	dpZWHyZ0am+0WcW8fePIbw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6urqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:32:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60R9mS9g010548;
	Tue, 27 Jan 2026 10:32:09 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh982e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:32:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mIGnmr95YCOn8sYo5Z5Twfeq5AUmC782S1sdArxxdOOEm6hw+r9SjwUdNbJadXtN2Y1i0X6iwiPLcSyrVwkoqMrgQDiK0bfMp0oc2mDXaHrajEjJF07jzk0c0eSrrTcDaiY6U/+h5oLD8/w5s7xZstA1+0GnXaj/aMqbYGIL59PigE029FSoLYmlIf8UKHp4jRvS6+26hPxRYNOFq10lhcLH4LyHaqBhaQMp9PTP3oZiXWNlBbpZWfauBOao0MeXE6s9SndiJ4ZjQZhgnykBVltjv3MPNi7/BomGDG/wOxfv0bTjztExkuUi752YBz6M9dWmvjCF4Gat29f8x91Dgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvigPEtAeS/J6qDiaRCpXtByy1AJ4rXQ82hr/ls2EbE=;
 b=I6mZQs8LjCEfBhPiMTNhPWDSzNj2Pt43NdYIixvJTFA/fVtOYGYNqQSlfv066ttiKUptjr4hmHdjy9R/m4W4OA3M2pKQPieya/e4edbrBnyIaNOXIuVkqKev/nsMJ5nrndk0LFc1/bbJGwRQN5+gXd9oAMT+ECsvwYwn10j3oOf7kl+8x4Y6pVYxkLuFTMaiwXBTg/dCSFvlxFku47L9qXmJP35NXrrtzuYwxDFCTEiM6h7K436j8WoHSwEDl7czvFXCYhhpacA6YjSTUmHXi4BVg+Fk6zihagbiWefNWNJ8ZsB6QSGNRruKhEI0BuPOsCQysPNvfwpRNzbQrRCckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvigPEtAeS/J6qDiaRCpXtByy1AJ4rXQ82hr/ls2EbE=;
 b=JesJ5De4MUfol6alcfvv0BrPqp8s9KSn7IOf7zFLpSNM3t8+mNj+tn7sEhSYXMASpZ3WYuE2r4N2gJynJoql0b9ZFMu4Og4IvH8XKCxUcI7RJRQg91Z+FPxW6mOlX562uVydFGEiVRakOFOXHuUPeowtFxARxjYqDPLPSh6jPyU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Tue, 27 Jan
 2026 10:32:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 10:32:05 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Harry Yoo <harry.yoo@oracle.com>, Hai Li <hao.li@linux.dev>,
        linux-mm@kvack.org
Subject: [PATCH V1 1/2] mm/slab: factor out slab_args_unmergeable()
Date: Tue, 27 Jan 2026 19:31:50 +0900
Message-ID: <20260127103151.21883-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260127103151.21883-1-harry.yoo@oracle.com>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0072.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: af0f7c6a-ec7c-4f25-0e6c-08de5d8f50a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NAgABT6HukUSnvn3+Fh/C69XGaA6odSxWiG2rf1an1cd/6QnmCQ7Zs0ofCVR?=
 =?us-ascii?Q?aeaWdEVDU6CMpxhu+JECI3sFvS9Wm5fEZXL345bxwR05MBEqIy8FUVNAJ5+D?=
 =?us-ascii?Q?Qg60/se8zzp3TFrY/tA1twO7cClYgSfWRij5XKAqk17xfsyqD1thRjyxP0nq?=
 =?us-ascii?Q?QbSGdeuHA/9ojaH9/JlSZMhHKhFu7q9ugodINTjfpAKAIfIZnknAnu++Qoi5?=
 =?us-ascii?Q?Yu74zjAa0ZcyhGLbX2ZDw1W2Sg6QEQ3EkhDK3H0B6ylRlRQQys+iNIO6kRIr?=
 =?us-ascii?Q?h0VhTiLpyO1jV6fr+zXMUmYs3QMsWKGZZuHbjAZ+/Age8/J51SmzVo1nRHML?=
 =?us-ascii?Q?/6n4q/JlnBv45W5ijSVkRQCBtrWMvWicEOGFe5KPX918IRY5rkR52c6WO9n4?=
 =?us-ascii?Q?CNBV3PN4HHVxrnapb8ukhHGVP306y2kb2hIIBZLx6tn90YX7Y97ytaG2yw2a?=
 =?us-ascii?Q?o9kBGcMGnt+BtF123U3Qkiwdp5aDfGPVE0To5TNdDWwAfZN/hbiTtT+jVSZT?=
 =?us-ascii?Q?lYi1Osd5LLt4QA50YzNITbVAeAL/VIq4Nwu0OTEwxhmb3/uJTox8hNMn0cE1?=
 =?us-ascii?Q?fmrxTsN7bSZbvjaF6MCBqn+N3BlQnELXg1veFEuf92B5Ah72ex6ouqkQIAFe?=
 =?us-ascii?Q?8Khb8T5de3wNrlCSus//V2Z+7yMc8M/cJVciOerwMh/fSLctBmsUiwCjaCTz?=
 =?us-ascii?Q?+B9xaHa73w56kq2gjcibSRxWZck6pS+HmTVSxjYOAA4By8pV7/7lVh7JCFne?=
 =?us-ascii?Q?74cAXEXc+ZU2HjkeOHAjCnCwHEX447K9dsAwcmrfpwn/IDa6IEn1p4rQccfx?=
 =?us-ascii?Q?oRvTLVg/iS698CE2OlnbBWmGAsGByLyJyIcBn/Yvyo6iMLY0ZEG26HUprEzl?=
 =?us-ascii?Q?g5/v7pbd4dDiaNku9l/uHv8KMVaRmxsGPBPkUeiOS5BAkwLDl5IFH2VBo/rT?=
 =?us-ascii?Q?lY/ceBJw0CdfUWDkNDldUQ+akx8r3MJ1eUNhKA6QPQGftpwElnYmRZBc/KQq?=
 =?us-ascii?Q?4R3XN0UsNybGhnl3Ai3Ryn/D4JzPFoGwi7aGHtbXiaX8KGD8Vy4k8N96GxFv?=
 =?us-ascii?Q?T+NUb4qs9+Tw2mB801QPA8ZV31PTRsAuT4u8f2WSyCvNkgTszCRIRXOffzuU?=
 =?us-ascii?Q?glU9wiMRJr+yFnQBtNYFmUlQrZmi/tA4cg41jyESC/uSfHoJWCAizYlGuOlq?=
 =?us-ascii?Q?QecbQkGMZjKzPoBFCxt+LgNxml5AWcq1nc1U43OL0N5erSR5Mk8rBWKSo705?=
 =?us-ascii?Q?POagVO6t7qW/dIAfpXmy3/o2pGNxgnRzLz3Uq6/Z3jYdOQjkbhCKjxNFEW6J?=
 =?us-ascii?Q?Qusisvv58yFMAKMTn4Unk4hgs0rvuis3xZZXChexxjg4IjAlsWUT1Tz33bqG?=
 =?us-ascii?Q?Y42FxjkZAPwZCNuf3oZcJ9KJcges5PWAE3sGWsRYorBtlw5mxuCZqu6ZzH/V?=
 =?us-ascii?Q?znzzOqCLhNsEmQborf9rzX6wZqCEO8HjipFy/V+jb8bc4Kosgx9/UxgaPyFo?=
 =?us-ascii?Q?ZfEjQtg7/4NXVdkUplTzeMXTwFmO12z/o+o+cUyuZ8SF+nGtJUnnYC9BTCO3?=
 =?us-ascii?Q?eqk5xp3rzVChOgIZ57s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7g7fNzUwUlrieRUe6CNrhQXdBBIXX9TwbVw4ZjruGcOg7t8la2aAa9QEqDa9?=
 =?us-ascii?Q?kXoEu11+XmwzG/5gbe96jyQKIy3fwtLzAExwt3qfMMHDzqqTv6LVhNR39o/5?=
 =?us-ascii?Q?xP/LEeFdfBaPRRlB1p0HjcZ/f5diiaWXK3g2WDFDJB1dALOALEsogXZBPmPq?=
 =?us-ascii?Q?U96GAyay4IMR116dZavzCpHD/QbiIouU9qFwhyjNWwym/3PHR7uH36QabD+s?=
 =?us-ascii?Q?kXE+4POceOgLL4nQk3+yDD/ppatlGpH8JUSZCd/VhV9hO9/iU1vzQwEN7gue?=
 =?us-ascii?Q?rDTPxCxI9tvMByu2FoHKeG/lvrlPTnTPD8yeEIR8+MqJ7iHRxqB9NybhFMNL?=
 =?us-ascii?Q?Sa2idu+B6btieBr9WJFba2xpWRJeJhtR/JyAL6kM7Buc2Q290x3TSn06yBPa?=
 =?us-ascii?Q?kTJwJ/UKtitX/nkiTRr9cWUZ8Ik+PFYlZMedrnoUQMmieMiIxAzKD3/HRwhJ?=
 =?us-ascii?Q?lAmuGM2xvbil9wvx93RV0NuTuHYz5u5zhKPRFqlEOlxB3fnLdWL8vAMZVoSD?=
 =?us-ascii?Q?hWjVY53PENhiVAlxaU4ndO36R7TuIvmUnxqGhnGSCzl9FgWf9fPlHhXO+S97?=
 =?us-ascii?Q?KKk20G6BoMk1fTg6qh08ugWLlF5NJ60GEV2eomaM2+PBFXLsTAjxdA38uHdo?=
 =?us-ascii?Q?bfsN2qzdEhFDnWzFQ/FardfHCLfdWBQXjAn2rQKZI0OZEKqwsEqbqpE103uh?=
 =?us-ascii?Q?kw+fItuXLYGlzEzgQwQuo/H+deX6HS4itUQG2EHfe78jWPeopsJ0mEcVTpMC?=
 =?us-ascii?Q?HrPQyT+IwyBkWtl1rF8WWHrd3Aro/e2YMGu3HQArKx9wgnpEj4zIJ5tQpxo4?=
 =?us-ascii?Q?BiDCnFJ/17A2ms2pqWwgbBiEU+yYxp+OTIUNKIvQVRQ6ynKFmnIHCZukxDLc?=
 =?us-ascii?Q?RyQi1bNIBdNd87aY4Y12StCP2J0kVh7UmBBCgDEkUWYdgoVZGwMVTRwUhqtv?=
 =?us-ascii?Q?f6Dri5GXoCrwMnMx3u+n0IM8NMOw9KeG79O2e8m3ICu721keI0pmGf7xxVCl?=
 =?us-ascii?Q?9FwR3wJquVovHsV/9wiX5iy+6DKkJRAyXRONUYgw4yNs4xJ/D7zb8m+yS3hK?=
 =?us-ascii?Q?bbxn2qVz0OLMHzlmL/UnbLAjTaRNFf/heGHE6RKBz7AR8cmg1HQQ4gPLX2c9?=
 =?us-ascii?Q?5pnXguR996Apg0xOOz6cojDbNsqs0g9rcC6dSXle0+qeZUh82SnP7nHcRfIk?=
 =?us-ascii?Q?cLbvKxVVkft+GzQxfy8S2mfHuEYb/4Oqz/YzU6CepBdEq0dHEQELQ9OsHTGr?=
 =?us-ascii?Q?6jWVEfuCsg/oUGl8hR103zirOPr/xAM3m/TscjA0ZimfXynGTbFMrCQm/YLm?=
 =?us-ascii?Q?7LTb9fwmD4X0I9CSvnDO3OEvvIN57gVPfPkOIr+VEdbeSd4Zl0W0pBCo/wkg?=
 =?us-ascii?Q?TTli6mpqoePGXF9LAb1l0pfaNJEqcxNbnkmyGjKtG3ATM87nYfYnz7TTNgLl?=
 =?us-ascii?Q?6l3D7JNOyEHaNROLzqv5gir/Dz7Nv80QG5MCTe0t/fSISJQku/90DQTi8LLh?=
 =?us-ascii?Q?AzEMpdO5Ja97T15QWa1Z7Hcsogdb49igv69y0IrmP4CMNKQUJpwKLfr5N+kC?=
 =?us-ascii?Q?/qMZHyxoGliCYr3Q4ETNSGSKsRlVCA7yVK+YE1UVFswYv8vmy3/8ypcJjsfQ?=
 =?us-ascii?Q?0hUxaukoUW/AeyTlQ6CpYQCjirGL0oaLTc+WuuMBVj+gSUdU5QdqYsiLId4k?=
 =?us-ascii?Q?fORelwxrdaS4cnjR97vQ2aJSH6mkxum923UAyE6Y2n2lr1B4+St/+wiCEL3M?=
 =?us-ascii?Q?3SrTDNbIXw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iMD7oV8WBbbwju3opW3EnicjNa+PWDE5QQ8gdlQyl3PlhZ/1dUYIiOcshjbvnPeKYD87tRPbKinKR+aD8rmkaXsUUfqOvsfvDXAwej5cfYYjhJHKYmBB6Ir7M0aNrb+bCiKX5YX0gXN0scSdBXlvoF46d1sNZrRelmHuvtb6avK3YwyP/CUWxLurk/IKBm8/vUZDofgtYE9aTrNfHij/bPXophjbaSXKoDkAJp+s0FezX9v0FKlut4M0xh1v2hFTTAO5Qv549YCYd16r0h7nCUf1vHVqKfJZPXTuJtuk4Jw4SmCnMUVaQfkdD6qORUErfUjBwVDyPAVOf2p/I2pJy1CeKEwu3RT1HKHTAs+NxeXuSQ8CgInt4qmAu/Yodq7Ze+bKJ/wVeiSd0NZ+X1A0mkQEV2m68UfCxk+T/0PWxnqnl7a/CKLDZQGQV/qin1/75BbRF3j4+FRhnf+z5QuwBS8WNfnHiGz3SSauVpoTm6VruqjoghbTSwlCW5nv9BDRuG92ugNDs2v8cx+Fsuk7prlsTfp9sAI9zGausjAFoSNt/OsP6VRog0cLQSqW1KBF4ou/WJ0j5tYtbGiPKtKHXcw2xQ6BoTPTYY9QBGl9nwI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af0f7c6a-ec7c-4f25-0e6c-08de5d8f50a7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:32:05.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7QzaGX9nbVpiBf38Hxs7NTsiinvnTPueMykjpGLeIRven53DIeqBfyk0l+zOBUfeGUNx8dWkPsVJTg/2qrfLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_02,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA4NiBTYWx0ZWRfX862kAVsn8KvV
 x8tjSCu/hXatsbeT+q2IrbXoXnw1kpKBbnFoQKSbPOBLfDiLbk/iJdf+n2Wiw6UccaZLCEH+rsD
 jMxIt/LgFDVdgWNoElmruOAA0oSRhHQRDONlYJFk7TrX3l0HJpaaQhRlCgjho+REz55mFYf1sBr
 TJLzcOu0qboSlnWDLqu4cMH5i5GQ0c+a/jI74ISkLFB2vCoNAofRVctYTRBdv3Ge0bpuQ3ae6rC
 3tAfVjdLs1Bf9ncRGh2u7m9mYBDCEFis46CDF9wtGvAK7GwGs8ZslmWz81cCTWEmA/tI5e26UXj
 lWqH6e0Pwagg3atl0ZUTM1797K5jIZvKERCkMGjaN1qzXPPyX7/OXskJMg3IhULuQwFfxhH9R3c
 ce6R6Sqpvje5YAhoJeJDZZ7ENy1pTrg+6aciExdYJaU96gHqnV8a8X7wvHTHB0G/++Is3tx0rsA
 2K2zDwbZFcNBOXG0ohQ==
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=6978942a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=T9gG78E8ub2x_HNiU6UA:9
X-Proofpoint-GUID: Qj4qY7lYO3lSIt3sTp9dPWED4Js2P1LZ
X-Proofpoint-ORIG-GUID: Qj4qY7lYO3lSIt3sTp9dPWED4Js2P1LZ
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDAB6140003
X-Stat-Signature: nphnfq575csn7xn9ntjeht7ohw4tn5mw
X-Rspam-User: 
X-HE-Tag: 1769509939-319729
X-HE-Meta: U2FsdGVkX19jBbQAXZS2Mx3PBSBn2XZYyNQs/c7arM0Uc1d6lZ4It9mn9XBK3XLSjr0SBF6DtNm8/yW1vRVtd4LqYCyMH3yHuyAOzQmvzAo1Gd0Jh3RhKDcf8MaooqVr4tI8PXh4e9e+EDr66ckKcen0iYPo5tMf1FnslE35S+zbA5yP5BrrNCBhCcqUYHjuaW46sATPFt4ykhfQUI7OqXQcN0qUzc7M3NFLoTKbAtgogS8lUwLzgZpPY/Ajw+hNHm9P8w52MygtWKZ2ex+mEJygQvVMfNVhr0YgWpziDNBzeQJKEEZvplD5w3SDxD4Od6w9P6uS7PotDSdkxVPsESauORaJoR+fo3msFub+IuQNuxU/YvZaTvd25d55I7kjTb2KCk9rEiapOA0wA0wP+oH47ThVd6c1sNioC7TNi8cqFy4byDOViPLVD4g2gp5MzVncUvtWowPyDUH7411c+n+8EjbTGIMED7xPFflSiDCFE/EDwXO/EEm26v8WYIb02JAUOpArYPUMeywBWmQBKNkpiWKf3BMAgSc6IenHb8788f0atFnTBtgICpyc/6NlT74D7gFH5YL5T4zUaaG0nbiyDFWBdLjShbp6Cn0+r5Fw18cg2KgpdtcSzDc6FdJufphVFZqICNBaDLGOdpqQ2fRm+QvCzPU6CWpdiKOkzZFsuPMe5ErnzUXWlrPJe19I4A9vEoAJdt35cmQ+bitCftvJw5aeA3gFNCWg8xxlACg1GnY6ZjYD5oCHn0aWZfQH8wdDBzWNVSrAhZHTYuMrfAYmOZcqu3eMfUIRz4OOaAEVNA4MZxMWk3dXAdMjaARO+AlgV+NyDHh1oTJQuuWxwEUW2evFXs0tP+f6WueRwQOoWd9SAgVUyk5bphZ3XBUV++VN3hOr/9O6Xut2VZeBF+a7001okrAVaPWAzb583joSPQw5CUbamz3LUwnNiz0PVeGKJ4RroRF4B1CbCji
 ckSOKYF8
 RGab137Nh/XWbCGou+l8kk3aq2xEne5R/lVDbgMHOIq2tXZ8/MfHb8318ohD9LhXEI4IdycT46rUI2AQ6UYfK3GjiADsjTjWHjxwdXJMTNZkeOxhq/c9JlGYYN6sngd1IXQvTKamb6TC3E2gK2JXKz2zcg+ceJzS3DlUuKgJEtg5UB+ftoOpccSdbU2MioVKSFsF1lF5YFVsxiJpEA0r+bJ6GcID8dsj8q/HyRwkBY7X9LRSIrDxagtPYDgWx3pe3GFtdYmjzfY1I44GpCrfOChSwLjkR3UqLtmUh1DiMF5jqR/57jrZAap295GUmirPmt8YM6kK/kFG79x8Wr1oHxOs6EIHZcJbXbcFQnVh6Ogq/UCNFjSbaLil9+YgSX9FXBSnCFPM4FuMJsQMGPmIO5cBuUsdkdVG9KDic8kMIRukyaYfjKNFGK88BlrMXANyIcXWr4P67YQH9oXIXMA6efq2OH1IO0Orm29jNczjo9HC7Rtvur37xnosDZRPHhiEWU/pj0VUXZtjNG/CwQZY50HYYszEBcIrafrJG9mJXM7+0fG/bLuxulXRTQEJebz3PVhJVDdswAumLzhneMeb1F0HVu0e6TCR3DmP16Ki70HS06Y+KH+RzPCOhut+zJiD4uqDPvJ9E5fqZPuyQodfLGeMSOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slab_mergeable() determines whether a slab cache can be merged, but it
should not be used when the cache is not fully created yet.

Extract the pre-cache-creation mergeability checks into
slab_args_unmergeable(), which evaluates kmem_cache_args, slab flags,
and slab_nomerge to determine if a cache will be mergeable before it is
created.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slab_common.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2e80d323f550..904414c3ebb8 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -174,24 +174,32 @@ int slab_unmergeable(struct kmem_cache *s)
 	return 0;
 }
 
-static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
-		const char *name, struct kmem_cache_args *args)
+static bool slab_args_unmergeable(struct kmem_cache_args *args,
+				  slab_flags_t flags)
 {
-	struct kmem_cache *s;
-	unsigned int align;
-
 	if (slab_nomerge)
-		return NULL;
+		return true;
 
 	if (args->ctor)
-		return NULL;
+		return true;
 
 	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
-		return NULL;
-
-	flags = kmem_cache_flags(flags, name);
+		return true;
 
 	if (flags & SLAB_NEVER_MERGE)
+		return true;
+
+	return false;
+}
+
+static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
+		const char *name, struct kmem_cache_args *args)
+{
+	struct kmem_cache *s;
+	unsigned int align;
+
+	flags = kmem_cache_flags(flags, name);
+	if (slab_args_unmergeable(args, flags))
 		return NULL;
 
 	size = ALIGN(size, sizeof(void *));
-- 
2.43.0


