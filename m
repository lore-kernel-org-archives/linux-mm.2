Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1F4D4A60E
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602FA6B0096; Fri, 16 Jan 2026 03:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5904A6B0099; Fri, 16 Jan 2026 03:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430C86B009B; Fri, 16 Jan 2026 03:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1536B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:43:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAF1D1605C8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:43:35 +0000 (UTC)
X-FDA: 84337188390.21.E6755B1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 990BA180008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:43:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lDgaLqUK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E0u+TEC2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768553012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcxrbETf68S+HbHOqeRq9grJ8HdDhKrizMemJUXAz2k=;
	b=krPQtRtJOm3p2uEvgS8kme/RubE6z90l7qPVp88JP8oC/+9geB7eWUZ1raP11FdB/Hq/pv
	RJYL05/sdg6sL15H7TEYP/4UsowfVg5pw2kMzzjGiutnXG9oMe+H1nXVvE9e1qDTT0BcHg
	pYf3FV3d60s9ZEOCjlUtQmiyOkclYd4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lDgaLqUK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E0u+TEC2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768553012; a=rsa-sha256;
	cv=pass;
	b=6P7VdhGTsTDodwWHhCe/F8WCrE78/x0WqI0CPln5p6b+D1bRlJJmYVWOEH/6qXlE15lPWT
	t/cgjZEel2MoSwG+E8IrBkfHpkl/R+SXQ6k9S82/TzbAi3ROMx57twiRIygrR9vxYtzhoB
	5FoYH0herQnBtIis+tzf7oXvfN/YLOA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNDcT1909898;
	Fri, 16 Jan 2026 08:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PcxrbETf68S+HbHOqe
	Rq9grJ8HdDhKrizMemJUXAz2k=; b=lDgaLqUKsFRSfPgWltiVdeebQPbFjafM+U
	VKlmdClr66WfDcySrJLaY7pgYUY1Vl4quKwNhVk6dZAO11LmNYOlKIQaRLbKaPX1
	G+U7LkQ51F9JI5YZiU5G4d5+SCuqyA4e4AykDeSjUSB//icqGs3D3NfY3C7/SpcK
	XsQRq1z0oTS0nMnsSIZmm4uswg+aIFOUjSQusa6oio7OdVZPtxaNNMpe0KmLmeKV
	v/cW3AFU4/anBTXhU425+N+qLCepW7lBHq6Ag2JWNcq/IzvH0eQ++822I/zssQJR
	hL+LFmyOBGKSDKnM6zMQis7BqpI+rSYhiiefjw/lrRbBS3bX76WQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nssdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:43:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G86gfT033952;
	Fri, 16 Jan 2026 08:43:19 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cngqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pswuyVKT4SUicZQ0D4dXkQ2aT7w7/yAG/H4tU4jaaV9Y0H09M0SndE3I1WLoaVr18DO4JxCuy8RBO42HC6O2EqLWtZ1Rh3Id1zi/7fYKMbn7yuaR97bpyBS2Tl42GSiVxvimVjSwUrKge8wsfprE5jfrVYQiDOOHHrwx4Q5CJKmah0j6MjCpO3Jm2Z2jtM6HL0DEAoyCRen6SB1GAxB3s7+niZOHZF1sy3OgLmSttQvrz0QOchEucG/Cv6u4nLc8Czh/t6zgdewPjOCKtqhjy687SAY7RcProAQ+6ae0SUuaGWUTBHu5zYa+fPMGQ1L0lEY/AOs6HyM1klwsqpBfEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcxrbETf68S+HbHOqeRq9grJ8HdDhKrizMemJUXAz2k=;
 b=idF2F0r78/0RNDY258iVpQVBbpO6wH1HkCdPgx5Gg4eD55Myei5XY1Pex+MB/aATSLqftaEK5Oup0UGLgPswd1ukHH5Ji+6WUmK8XBMr0Hd2dW9i+CpRwniClRev5Tod/mDfXiZo0jYocAgrOzSf0L1Piw7khoKPJ5vEkSL9kF4CU8WNnxh28n5wowhYL0GF95Ys91zpucM9HCRLrRPN9aQwVVpnY8pAh9OPriBswDeqMdCuNRW/BaBLtqOpHgnw62rV7+9/I0FwnoJt76io1+wuAeTHuCKEO8/TDn3PwpVSySygwvtHlzawJODnDEj9yhGg0xH9faASVvPHamsWsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcxrbETf68S+HbHOqeRq9grJ8HdDhKrizMemJUXAz2k=;
 b=E0u+TEC2Epkg4Ag9EeFqMdAYOQd9gs2I+F5dRPX1yO+o83YNsGdctKeHIG1O+MT9GtJHK5qTA8aLBI1tnlQdtlbBuRSaiXZ/9Kb+9s+EFt/Db7TgK3YRJM1uV3hOBWyPdVEyV+wk1VUQbqSCZYKXOXsrYYrVai/9CF+6XeJAGm8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7343.namprd10.prod.outlook.com (2603:10b6:8:fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 08:42:53 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 08:42:53 +0000
Date: Fri, 16 Jan 2026 08:42:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <c6aed44d-b1ab-4954-ae60-628851319e0a@lucifer.local>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: LO4P123CA0059.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc80c21-50c7-407d-92f0-08de54db3ce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7ZtOHo+1rTdejM9vdjLjmjscEZY3elV/pzni5+zsq4XFXVnD+4W502SFkay1?=
 =?us-ascii?Q?eJBZ1BZf9bPwPVagWFjTRBVWxBfG8mSZVT5z0LFcneJ6x86pomMJzjGjY2ZE?=
 =?us-ascii?Q?6nZfBmHNJTJM5mkvIr0rUJJkv7uVkN80hXMcXqV7+CJF1GF7RItlC9Kg3Ot9?=
 =?us-ascii?Q?Qjy0T8BZ1Q9A3FNi/LFtM3kJXZeZp4y2NCwjeg/REKVzjbK63RoE6/Tx1xPl?=
 =?us-ascii?Q?cQhue49/31hs3v+1soaVBrmcQJCYPyE2BWXpECk/bkc24NUOPWziEGmGjVkU?=
 =?us-ascii?Q?Eo3A5KRe/iY/zhoc71ZWiccY5fvxVdup+6XMMvExBqXD+HZrCDI/sGtushb5?=
 =?us-ascii?Q?iv9au2972Zn54yfr1uy/xKYJMljWoF32lElH2GxwTkRHxAGsUdUJ1QR2ZXJP?=
 =?us-ascii?Q?xfrLKS1mgDmmIyLjhfX5fsYxon2q53u+Rn7NyDfkdVUjIxm3ACb/wR4qtiwR?=
 =?us-ascii?Q?M685c1nxYXLnp09zwd6kQCzZPvsWEMFTdqsnyhvFt597qkMPjyEU2Ka0uKYi?=
 =?us-ascii?Q?CCZkKn0hk8An2WSYT7lHuP/qe1lwjzdRvbvLc2f87nUxG2nrtsWFsTUYI2Lx?=
 =?us-ascii?Q?oWGgApsT1iY4xxQB4zPd1RdSGMRsSQ36iW9LCzfZLMCg2fJvsOd9kjyXH7cc?=
 =?us-ascii?Q?W5jQyX1sZJpARJJTKmgMj++f+JKdeD8l9MIzcU+Dq/GDcZMvnfKnlKwfHLsx?=
 =?us-ascii?Q?H3a4A8yIxbJxENtZAyvMq4zumAaRvGeqi7Ewm6cPzp657LgeggniBmHaUebA?=
 =?us-ascii?Q?lm+ki/spAirbCVQ/o08DCvfrskB8hbIESzGrhpy3Zm1VXA/Xk5uB0UnzFemN?=
 =?us-ascii?Q?J94q9m68s3Zcj6ocw/PC5hF5CbXPI21MtlvQfh+sAe4F33ClxY60GKbKECbH?=
 =?us-ascii?Q?vyz2uFoMIebTVZ+/AMOYHv4GKf9ITPv55qUNQqUKBNc055FCzOJlr4W2J9Ch?=
 =?us-ascii?Q?Ymhx2+hVgyPj8gRD3gwb8xr/wvwQtn19/Xji3H3rfAE73Npn9aC+w1U3qOYk?=
 =?us-ascii?Q?vEYL9nX/62LQu42f3YY2SUU13Amlyp9/8aJ3FusG2dIcD8fwYyP6cbRGQmPn?=
 =?us-ascii?Q?8UYU549LFp6jodWW3CtCcZsnlnpylSWrZVndskxbWE/Ovohvr8i4s30dYNpY?=
 =?us-ascii?Q?O//ZhmPpLu7v1WBUKUFFRPtoMmzRviLGSwWAK/l3kWdtSwHt2ne/H6uSkDuL?=
 =?us-ascii?Q?q/5QNy1z++xb2+66t6zdaxXNlYRPrOcYJ4TakC9aD1NuD5J4FjNcr89Dk+dS?=
 =?us-ascii?Q?qnRo2duUxnpMbke4MeuNEmUx5w4dp3msu13sc4/oHcF6PKWGphdSICE+OY9j?=
 =?us-ascii?Q?4eUcklj99dItdV24IUMlzcEQZ3whQnpzMrtOYobTvqiwpXAlNaFTMSdZ3Elj?=
 =?us-ascii?Q?qZQOU6Z0l4ZaeHsC4rRnSV802UlVhT2A06aseptwZPLklcnx1lxk098T8wDe?=
 =?us-ascii?Q?P0u3mVzf8eujfXFTss0FP29lL8NuA2q/mOsC2vrxSRkccEI5hpTHbrXuQJZo?=
 =?us-ascii?Q?u5xBkLVquu76dYkWyM8cILeMvQEYWrS0NYTu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E9pX/0t156qjc+ZvoKAVJomU55mMHv9bU28lPCza3btSI25pdLamZ4gIIQrU?=
 =?us-ascii?Q?bTykTuZx9jBfOSu5qQ84bR0hYRj127rhBKv/bwTxnbpJwdmLoD8pPt1+ua++?=
 =?us-ascii?Q?Xo7AVV3OZ9XrOhssBpo3+0fIYDRqNY3Vr3kZo+LQx1Wv5z6AveCVsovCoHmL?=
 =?us-ascii?Q?Dfr5dr2Z0vPA2mpye4pzhHuO+5iuL36mIq5ztNl2GzKaANHhw3Lh2DSB+Wz5?=
 =?us-ascii?Q?jyDDvJCbIJq2yoygh1SS5MpmMcOpMwCYcPUIfAZ8lySxWC/WL6SacrMuyfqL?=
 =?us-ascii?Q?KwCc3CPGqBjOlEHOPoYvwuqDaoYXNSsyt/9xgIYz/+SFJGECxpGxKQkoMmOD?=
 =?us-ascii?Q?HpF0X5diXxQZ6O9GcsWwnuPsFHyKMxtF0yVOGRuHvTaXQWlAXZ3cBSyUVtx+?=
 =?us-ascii?Q?t4wcLEYmTdjMS7xHrnm7xRw21/ms2Pa2gUZvT/iG5w47iawaWajbay+BrPXN?=
 =?us-ascii?Q?LU2/O0cAXfVUSinDUFEKylWVFTrQQJ3Ercj5KtCGBoSmavPFyL38EV6Ihrf5?=
 =?us-ascii?Q?+OgZhvToZbZ47wybcZQuZAuChyGZeG7f6vt1uwynyTe2tIGayCBPgwcUwPwG?=
 =?us-ascii?Q?X3yyKmckacrIVzs9dNMl+5xrAL8L2aauOQF0DXCSg727EFZjh16lpyJ19ZZs?=
 =?us-ascii?Q?ldur//uTMH7NtzpHry+dIQG/DDrJ51wa6tSvv7uZI9hzsQkle0SWstHta2NW?=
 =?us-ascii?Q?993HKgZVFeo8+x9rUaWHw109/eox+1ahiyLyfhjl3LLVUs8uGwhd68ENiAaa?=
 =?us-ascii?Q?JZLdH7a3n1ejt62UctU48IyiPEIuuj4xCOr0Gh8eyWgqFttZWN23hT0wVMl1?=
 =?us-ascii?Q?vzUAhfta1VhN/K9K7ZzzJ4mF7tlcS12Pr4yLrz9x8k/pbwZbB2H+dP0wgxKf?=
 =?us-ascii?Q?7JXes+cNFyj9m9c9k/p5zSZGhJ3MQ2wqjhtyrIim9EEU7RR1mN32SHOQYSVb?=
 =?us-ascii?Q?t5mjd8+Ga9JzvFyMRsarsyYWXUgwbsc65m0k5LneGjuXFUe5OQcpzPj/ygo9?=
 =?us-ascii?Q?Kc8DwdvO5jMfhzAOXeAXFbutzi06seN86n/Xjdc71MHlrL+5QKCpocd7ByG2?=
 =?us-ascii?Q?mXt0LjT79XbcknygLSGFPYLndgftuaZD5Qp5hsp75XYyz9Sd7uKQs1nMViLH?=
 =?us-ascii?Q?GihQb7lQ18+tS8fvw/QpPcnUrn75zw8eleLbgHErJt4stEVcJfVTCLtaD8Cz?=
 =?us-ascii?Q?wV2TOhYsXat0H1AWnqIlyFzOPLzqAtfwaZL82knoIyOPdC3EZk9ptO2fXNvd?=
 =?us-ascii?Q?rON/OtZGye0G9iXFmtpSdG4F4/txRYoq/pOTsDLnSPcvjWkq5jGHUafhyhj8?=
 =?us-ascii?Q?muqGRDEKxeKT/T4CJ+iB07Kj5sxoK2ypPr27BDm6HjEFYinx5QM0/TgO32ed?=
 =?us-ascii?Q?qvizjd+nLSs7W4wWlEYZgGqoUrK7hryddXj7Cmn+GpGzX+tCeXSbfVLDllvU?=
 =?us-ascii?Q?boEVlr2Q7l/c5WwR2lrJ8R8s+yRcgMg5rIuBPhH8mghCt90O/h+pQQF/6rSL?=
 =?us-ascii?Q?Y6uUU6m+guH8S228T//GUYE2aIX5+Lvgsk43x+f2CYYDTP4WHmutkaWkYDS8?=
 =?us-ascii?Q?ktIrGRiRUZOQudPbatwlA28WBD9L4AbEkxNGez1nvXbDbaY75Ty0slvESHvd?=
 =?us-ascii?Q?Fy2RSDcvcebthe2PBLxHpxSjITGA2Rjd1qDbrJ/8+GhpnAjGXPbhlXCGe7RT?=
 =?us-ascii?Q?ce2C6fOO6taNqrJ9i154AebbX8ppySo0F9YiqGmR3fUCW4SG2L8+Qf6rP1dC?=
 =?us-ascii?Q?1nYKQo5xrMG6eH//0fw4fCcJNovY0UA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yggKCCREDD2vV3S7Uhm6DU42C0TG8vBZXeY39aQ1Mz64gFyZwW+xliOqFtvKs06S0br0BuvvU+M/0EhchELu/JymDwDFf5x/nQv5gPpEK5SmOpzsg6nwmrWGDOQ5SKuTs25+s0GWd1gN3FQjo/Rj53XKNw6oOxZKvF6Q6ccOyxXCnLarvcGVA47BflKDUS0+uUBemMeOmOyr/g3X7nFf9S6YT4KBH42Gq8tvh/yVMBvwTDEc6/IRtfQZKAISxA7Gy2Ntzq57phLwj5/yBCISc07vzcXG6x4cbvllrpX0zAi0X4f3Nwp9pNs77cxT1fN4yNysgX2NlPwng0VCm3A0e4M1cHNnmHRSX8IMoJC1arTQJkYO0k2hvoO8khnp5v52BGkCCw7lxAPA56QTvxG0JQZokEhVEk4cYyV7D/mmlL9kDBzpAku4tot9gIn9W2EWNz0UkZCIJPskoFeD7RbXfGbdzBOpuSukd/Hs89jRgGzmjD0J3P7bhpx25LoM5X516GJRn6eTvkw+OCqgPZFAjTTzWW38I/IPfxyxAYipY9pESUNlwEoBZULB3F9oQ2RS9zdIY7jSDJOMjccVgaUyjzYhlnCSKLSMwrU3xjFLy+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc80c21-50c7-407d-92f0-08de54db3ce3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:42:53.0794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uf3/daLN02m7HGCuDIU5B+GtQugBfpTSr+SAUTHOovEoG2F5ijfghYK2FmblTxBvGapY7ZlS0FarIoU3j1+P6vsyzDjk25MGtxEvjU/TVy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7343
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_02,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160063
X-Proofpoint-GUID: R-SyDepxNkYJymz6Q7-0DDVMPMiYxgJP
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=6969fa28 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=pGLkceISAAAA:8 a=SRrdq9N9AAAA:8
 a=ceVHdk0xptWYFJi85-MA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA2MyBTYWx0ZWRfXyu8aKtQ2jZqy
 P7e7dyw1TfY4RTJgyZ79SnZsEAltjEYlWa4BwAE1Ft7RohkWqR2fGDWezV4iiQVLHgPVAUSMtBU
 7XjQbWdurs8Vi3WMH179r29Pi0QMFu0SCZodco9h5WKRzWyM7x2T3e/fd8lA1KxhiweDW5WWun/
 stDy1KIYFRvxQQc5rL5Jhq2R757KT5idKWe2tx4722bNzEV6Ios5C2X61roZRJXqy0WTJ5tg+ZV
 /vpyPochMl1uIVVhWWNkncI8wACT3c15MYbBr/DWkC56ZbObCjgsokeof8RrQywM3ipkZI+w90h
 HZEeqFMmI6q744eeYU02aRqvHCzgk7WTfktiDXJ0ZiUkgjiQqqZ8dkYc+K+vMBCGWwxKWtPHD44
 /40VHR+wJwwL8z5Yjc2OcPhExNuL0vASh4MK7zX+ASAQhYV0WijUM8EcY6Af6tKpEAZOi8Vs+41
 i4KKS48J2wH5oWdyimA==
X-Proofpoint-ORIG-GUID: R-SyDepxNkYJymz6Q7-0DDVMPMiYxgJP
X-Rspam-User: 
X-Stat-Signature: feg5mfm3sj3txbgq69w67basedy9dk4b
X-Rspamd-Queue-Id: 990BA180008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768553012-823721
X-HE-Meta: U2FsdGVkX1+4PviAcX894oghdhK2VKnP1THQK3LLOC+lsb0sYCvohyYJcGZCeIWh0QZpH1jQpL57cyYFh3/1b+WmJbUGImp8H5MrdYEwQEbwGY161Imns4J2XtgOFsKGQvMRb9uxDTWGS4GvcGqkiA0Y+BiJoirME7D0iRZMi7BYea+GdctGcq4hX35J9JasveGZOCVnQvdrCtdGBtDPjFMpdJr7g7crulEaWbC4YonJPqu2vZKz2N+5kc1AtjXGBvnV8+TQ+hGsKqWnueZZl1pRQXXtM3WLjnAyqXi0i4VG63MZ8S468/2vFGKR33puHypP/tUbFW07zG00f2lqzsaxg4mOQBuF2J+IkT2UNYQOC2tBsxTywpVdD8ncXV0GFq8Lux5zRLhiIHWpH9PRp9WC1OaX+7gxiL9ZUOHofnZKWJ4eo6Z40yyG5fTju05G2cTJZwOI/777WbbSl1mhR9hl/eYczuCATRQ9HQJaPpu7Xw7MlyNftvF/FLa20MYktv1GkTE8H4DIj08T+20JQIqlHUH0TbDtM7xLSVxMzWhHnEvRm0BZ9M8PDcttS9IPdoQ5oAtNLRGrO++tsc3vkSjfZ7y8N+C5BW9//HGPdguaQtdp6jBv6infsXR6sXG7L93UlniAxzI7fd9/55D7ZNo4Z1KTVj9132URJXs7X6YOyPKwOmsnIQ4GWdS1nteucmwWtKxlrymtWxq8WQByL7ADzn3xvSqjoRw750QNy6pZ4J51fEV7XYymO9s2ZAgLpHHDsUZHKEbN6l7zRN9SIiYQyLm7XlpA5IPvEx4+/4krlJoPXVvKMiI+/Vly41XExpAfRRZzmEFm4+LPRj79on/GgA6xvAU03s/tpW93IC1x3fQXYPyvnhIOuAYFTZHWRuC+8WXooC8PibSIj2coh3yPYjK2KmFwY6s2d4oyGiIRVtqtt+hkhdJX54lrx1HKUhzm2FBedqzmbHOA4LV
 +AKkY46E
 P0inVv/h23ulVC1fXxC/HWCGdaDFfnsbX9ZbqYarjXZ2D6sjTo39MDOx5boPgSN2v5/wY/edB6AZY7P0RlTBrFMRWnvOX/qQmwlXWnYWdjIpL4oBbaVj1Hq0Ou5LkqVtHJI49YSRFETe6XxC45fzd0Txr48f2t/ZXD5yYzgkEylb2j+jclxqwv5QryeHbCNlOBNhDryXNCfdXopncDKvt6PAexDpJJcCNZuPG1HtM00ZA66YXCxcRCwR7t9BoNGT+PMv+iUegeHU6DAubH3GVKwX8yLXTM4fA9e3N6EH5+0oSJiyvXafEns6a5W2hpO8xKRB3vZ9yGUdtITeYkbiSo3HuOtPAgXydVHRv3R9o+R8teLU8YX8l9bhgH4/V4Ojy5ver1tlohI8u672NShB/N+970HTzs9F4RcLqCiGLF2pMaP3ZL/sPKwpWue6nTw5wVNkSNCKom52avNsQCNpSRDEWdCZetWPMzivopLVrpKbL1pQBlQktOxLX8YiJcoeTGIpSdLXk5MToRkmvIfWpxOdVAiaIQLoiLFHhGwh1W8SCrXL55HawePQFEVZLX+tSLmhxckORmEgPzxz7lMuprjlNFfOc5l34YSq20UsuSi4gZxL10Tz+RMzXANhiT9VGUs5akEtRkOwuI54YfZF5L32I8amn1BJSFTtnSPOMnTh5T3zL4lrYG6mzPbQC5PHUYlsks9b9FF7ZcUwPkkrF2iXu/IpPFg0I280r+Jk4AWeHwitnln7BjME+yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI Dev found an issue here, see [0].

[0]: https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/

Cheers, Lorenzo

On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
> Similar to folio_referenced_one(), we can apply batched unmapping for file
> large folios to optimize the performance of file folios reclamation.
>
> Barry previously implemented batched unmapping for lazyfree anonymous large
> folios[1] and did not further optimize anonymous large folios or file-backed
> large folios at that stage. As for file-backed large folios, the batched
> unmapping support is relatively straightforward, as we only need to clear
> the consecutive (present) PTE entries for file-backed large folios.
>
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
> on my X86 machine) with this patch.
>
> W/o patch:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
>
> W/ patch:
> real	0m0.249s
> user	0m0.000s
> sys	0m0.249s
>
> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Acked-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/rmap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 985ab0b085ba..e1d16003c514 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	end_addr = pmd_addr_end(addr, vma->vm_end);
>  	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>
> -	/* We only support lazyfree batching for now ... */
> -	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> +	/* We only support lazyfree or file folios batching for now ... */
> +	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>  		return 1;
> +
>  	if (pte_unused(pte))
>  		return 1;
>
> @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			 *
>  			 * See Documentation/mm/mmu_notifier.rst
>  			 */
> -			dec_mm_counter(mm, mm_counter_file(folio));
> +			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>  		}
>  discard:
>  		if (unlikely(folio_test_hugetlb(folio))) {
> --
> 2.47.3
>

