Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8F0EDF024
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 03:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2296A6B0089; Wed, 11 Feb 2026 22:11:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA526B008A; Wed, 11 Feb 2026 22:11:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D906B008C; Wed, 11 Feb 2026 22:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9DFC6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:11:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FDA31B4104
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:11:58 +0000 (UTC)
X-FDA: 84434330316.04.C60E95A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0975D10000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:11:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="HfVSa1/2";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pIzBB6Lj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770865915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7j8+6F3GRR/2r/MXSwBPtbPusCrg330WysBJkPA7OA=;
	b=eorlT6Rf+f0IYj6hHhsLAHu7vb/YQyIZ+QkVVNaTzcdVHb+tmBOJx0jb92oYHmwaDVfvl7
	iammtOvvfSagMNdFPK+yFSgQpwWPuG9xHMwUtBo7O6bYuwoyI4PangZhNjVnQ24Vyb6U+d
	kHrd+2xWXv9ccv6ZLdOxysb/9WpVZpw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770865915; a=rsa-sha256;
	cv=pass;
	b=51Rp34pKEAMyfZk6PiCx7JQ399NKWTBjmBkjh+aUr7WW64whS5W44Jvx+a+0UrsjRGTxAh
	6zM+hrogEtkEAi0vh2Y0NK1GTx+8iBH4F29rJXAcx1YxJuanyE3GLJhk03eFduAxfmk8j3
	d+k/nHW+foyMEGDJMM2tu2mjllHLpZk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="HfVSa1/2";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pIzBB6Lj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C2CnNp3807578;
	Thu, 12 Feb 2026 03:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l7j8+6F3GRR/2r/MXS
	wBPtbPusCrg330WysBJkPA7OA=; b=HfVSa1/2ILwTKIKXlyhcODags30ecNXiYt
	acQynhKhWSnezy4U4NHnyHf65daZ0u5qet2oZCah/Kg9b7ToF6Q0jFRmQ0GF2RkY
	tvwqjRc2+m4oZuiMooe1zZCU10quNd6nAgAPWNnHY2yShxSi7kJGTyr395UiE9na
	3R/YJSrE8gXgg12Qf/SRuKOyqo/wQm85QMWvqY1QOVZ05/4INkYz0SwEXj31ceM4
	tpUkXxxNiobFwemOxEF6oxBZyzxBKcMFAFeXF5SXErc1086IFrA2gWQmuNEw8FcF
	FWkG9aScQ7F/ujYp18MmCql6iKlHasiBHg366at2nKIUtA6qEIZA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8y2r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 03:11:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61C0LP5x033867;
	Thu, 12 Feb 2026 03:11:50 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012001.outbound.protection.outlook.com [52.101.43.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c82474cpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 03:11:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAvipV/fk7nI8IbeT6iZSE9haf4QdgXZFhnFJ8Kv9Je7kdRP7ByN9/bb0mq/DOVQHfQU7QV31Quu3dWmIRtXx50+UK2bLIjzAYTPymDExnNDOZf4zSVbH9x2wQNbopsyMQd0K7+22LOBOVDLY9T38EIHlTeJuv4qB6GuCyJljFgYQs560mS0dl3xtzRpVHZ+Cv0Y6qB+1s+OpzCLm999s7/MGLRuTzQuSIZGaSE/LrKqZHHXGH6InRB3KwvL4IVfQc2j5Es+nbLBKR2C9xiptKixYH+5qW7+3M1UUITjtN+r0ZHPE+nfxqYu8UHWy8FJZtuiOKHpwkE1n1al7+1gnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7j8+6F3GRR/2r/MXSwBPtbPusCrg330WysBJkPA7OA=;
 b=Jj2Mt7P/CfrIOTAogXPI/UifI1u0tWlivpB9HZ3Pzi+5YAg5dMUz/9vhJco3Q62F1aLutkRpNi86d3dtfeE3lSZeodbBWBKeGVZgn1H0FC8CnQ5zx8nKV4+6fAsNbh2Nq+4TG/2lIJjZ/IWUJvg8NNSB9sBr0UCdMmCQp92q32uLFj7K8iF2zqphCOoX1swevHIEQnZiq5qyxBMumgf9NHrCNB7W9zgje/Br/HKQ+EMmT/VPHf5mipW/BsKz91vKQlu57C7rA/BT2wdmPDasMdaxgrN79HDInolZBDLd6/x7R/eiETZtNsSlbpxwp9OJQCTgkyhhr68UewqbnVvXCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7j8+6F3GRR/2r/MXSwBPtbPusCrg330WysBJkPA7OA=;
 b=pIzBB6LjmJscGQ6Q5qFLU8GJwb/To9rUMfP93r/J7IuQqa1FT8XjyKLLwItfx0GEMwFn7Lit2eUr3t+1zvZatqv8RCFMr15zLtoEcD+qCzN428SNN5xnoa6OOLdLOv8vYH1aygyuB88VKKexPxSfby+BaODUljLICs5a4g2+SY0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB6398.namprd10.prod.outlook.com (2603:10b6:a03:44a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.17; Thu, 12 Feb
 2026 03:11:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 03:11:46 +0000
Date: Thu, 12 Feb 2026 12:11:38 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
Message-ID: <aY1E6uf75pEOf7Bq@hyeyoo>
References: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
X-ClientProxiedBy: SE2P216CA0132.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: b4429278-9f4e-4d2a-2767-08de69e47449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qnQ+w89sYKyGduaqp385XxOGEEsYGs2Q1A+ePQNXGcqzcjSJN75ATVtgOC/7?=
 =?us-ascii?Q?hdZ+yorKBTFC2gursIL+v8gA/Fb6bGCLspAVAjUrqJwT/4m7MgR9NuDTKBbm?=
 =?us-ascii?Q?X57iJ/z2NaMCE9f/Zy9FsomHZtwSwUoLjig9V2MAoiF21OlKuWbqXwMOxNMw?=
 =?us-ascii?Q?Ja4vhIvc0QqyhcqVblSZ0mGjxk84GW4EEf866b2JeuMVHxlycdNfV6NTzMv9?=
 =?us-ascii?Q?JRg95z+e7uOTuY+Nw9FycD+v80dlAXG5ZD4vAvM1/7JPeKToPqR/AQEb1ZuV?=
 =?us-ascii?Q?nEtR5+N0M5HrCTdAR+6P1Quly4H21l7XECDoUvRqCbTVFh2uDZJ4tW/T/SK+?=
 =?us-ascii?Q?4I44BgvBnr+/nqvPe5t0iz4u4wpLnMGl2uxC/IqQspwvMsb/DiKUc+m9RTI4?=
 =?us-ascii?Q?jKwqyEvGMcdbuTHi8F65ontq2BLckcw7hd1IWzpny3Xqwkw1EBUhvZo8s8DQ?=
 =?us-ascii?Q?i9CDOE64WmLkkOGzxXJXW1pE72btimglbUBjOdUKvYvBtqZX6ln8aKfOlK3K?=
 =?us-ascii?Q?rMlwfSoeUUwxreo8fcrtzEpyCt+S9rR58fpjlp3s7ofFS5qygJHKzDPCfYKu?=
 =?us-ascii?Q?sZvinaDLX7tyVWlNxz580k4w62apH5re24jEYboQChuMpSG2Vvb6E+du2Rdb?=
 =?us-ascii?Q?6jD53/TtAckbeRffIv2ArA3GddXWs+d4FiJXNSRckX1YLPKgvF8u4shugPgF?=
 =?us-ascii?Q?NPHua9QoYfZi+UhNZPjq9wi83RYlJwKY5C25hWa6NXCQeqns66mXOmncEHhP?=
 =?us-ascii?Q?NaYqJ6NMM0N53WfTKf2FT95ARB30UCI0CJ061zNEgast48N1u1tD7LK9fAN8?=
 =?us-ascii?Q?pNk2ithHKJZriX7xGtoVHdCa3b4ZoDQkyYowwJVq6eg/JOhz0OAMKyM28BmD?=
 =?us-ascii?Q?HkQbGg6T7osEh6GgefMoa1kkCvAf5KV1/ARa17DBEhHhlpgWHbQwWd0VYube?=
 =?us-ascii?Q?Q//UcnxlTp51CyO6c1X2HD9vnrCr0Vd9taCRSiISSkNOXejIU2WFR6IYnlmL?=
 =?us-ascii?Q?+NyRE0f6xu+7m2A3eifPbOtq7YZx/0TT2izLAY+ArGZjsAQHgUsTj9NEicM+?=
 =?us-ascii?Q?PfxM+viWKxcgdR1cSl0W96mmiByS2csVbSH/3QFT2jt0k8sj5SUhiR+9SNiK?=
 =?us-ascii?Q?G47epGKV6TaaARYL8lIrzp0hD/z/hRq5bSZHgdEZjjAk/rITxh27SHRWW4P3?=
 =?us-ascii?Q?GEbrLRGLPMkqlm0wiEcEy9Ad2hyjvX2bGFfHaUxBsxMjIEyO+pOShmhxGkoy?=
 =?us-ascii?Q?4GICCzMSXHPXLa50eLeJ23olifTSLwr4U2xj2n/Sg/Fj4wNELYYKImxtbMXv?=
 =?us-ascii?Q?cgXhasCOgaKnSnd6Zg3BUbll13u92DcxyddP4x3gY+AUvD04FwlyMb8H5qkf?=
 =?us-ascii?Q?KnPvND9LxV+CyN5fvPaJv6omXqEoeBg3T8At60BJ843sm5EEUa7DAfP4f9eW?=
 =?us-ascii?Q?1CG6bCNJetzGqbJ2ZY78Oh78oSk/SARSe7KzLV3vRlzHGqbMtS2vGCGe2gDI?=
 =?us-ascii?Q?XTUO874A2AHbz60YErcI0PBmcNBgM9KQuSX8yYsEa4C28k+BO4P5eAdnoGwC?=
 =?us-ascii?Q?UKdRagbZMV9YA4VQd1Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C9DXEep3E4cCT4hDbl5JWJYyKcC254MvpB7eVgmq91HecMmisekMc9yzkIT5?=
 =?us-ascii?Q?skmdJNVpHeDeXXmkKEn4t9tzS4HsCZjMarCdLf4UrmE4rS5d4EW3x2GanLxa?=
 =?us-ascii?Q?rqaBbqiH+Qr3T5Nqe4whfi9jo+msWFslHkJbYqHpdsJGun0p0+zX35SxFpzB?=
 =?us-ascii?Q?nSxzoDltLuwpyjFHJmCZlhCvIpMWkdWDQx83pPnclLbJU/ebDfN1ciBNE7a/?=
 =?us-ascii?Q?h8mUsEqz41K+dj/tFx/lhpiEYmfohbDEh3D5h1TRrUbkm+AGIU1HE35+E5Sc?=
 =?us-ascii?Q?PwTq38KoAPqnjCzprYPTMX0DrwjiivxYOERFStaEIQaG9iTe+1PqpSHRhCWj?=
 =?us-ascii?Q?+3Crgwtc9hn7tF5pZZHLkocoq0YjP83IVCwL/dWPaxDxaKtrTnM08kt1ND86?=
 =?us-ascii?Q?bwOjx4JkKS5OK1bJhMQ1IZJvb6/BHivjyIQEhTsi/27WzqEghCUumk2wijLt?=
 =?us-ascii?Q?DJ388QYO78wFJr2PFF9zU/xDuUNyRrnDbhwCX13eQ0++OBLadF8ISmMD9Cn+?=
 =?us-ascii?Q?1HsZL6Y0gH9A/iKldstReA1kY7UeXGx74FE0s0GgXKOiyPRg4eYhxTMG7uAO?=
 =?us-ascii?Q?3Zj75Ql6WywwlcytMS6dEYpBSTwVHLERhzP6uWqE8umXz3RfiQ+an8CE0bsx?=
 =?us-ascii?Q?FwLM9sCGh9wF5Ytw40ndvO+O1nF2pTKatK3j2qeQM7eb76T0Yj0rhOaaWcNz?=
 =?us-ascii?Q?bXQjPtNLhXuIhZUAtcnGH0hnRKEqCls/dTnaJyGs354bffjfWT2/7Qw44FPm?=
 =?us-ascii?Q?riB95oLnapmm/DxxPTdh9TKop+JjGWGEdMC/1NMd/bwJtEfJ48kkJfwER9lU?=
 =?us-ascii?Q?iop3a6XiWHQtILFN72W1NYyomgOR8HWT0I5pF7vj/jFCQpvIpzG+0mZydfto?=
 =?us-ascii?Q?deUTB0QBkaJbZ9OEfzicnT/zfmdqOn4QbuH46SDJYWUL9LiAcl1JBr8rW6L4?=
 =?us-ascii?Q?S5FFK6rYD5K59ww19h2eInY07l0mEJk4VUfJXPO+l1K5Z3yFO6svuro0X2rQ?=
 =?us-ascii?Q?Qqjm9P4aTXI4/0lpGL2kjOdSjNzqbUfgR7S11PdndjD7EmlzHih8B7NpHQhW?=
 =?us-ascii?Q?SX5KthCEzWC1JXjzXq2iW1jPGDy8LSoyD5DXWOEo6IW79yZUYlYu4FXbnTbD?=
 =?us-ascii?Q?on2xt4XhMjuYOUUuFLRZCB9z3baUQeIwDx56QBS5I6DXZc/N93QtK+xvcMzT?=
 =?us-ascii?Q?58fLFAutROVzx/EAPldgMp2vlMwsqjIIyYiYnTJmUQKnLRiC148fw+Q3NcYr?=
 =?us-ascii?Q?J7VFCNHmfmv8uZVg0gbKSxmowgoZaN9S5fZVMJU3JkzZIhL70H8/5CVoGYye?=
 =?us-ascii?Q?NSsWL/XxGzaou3hbefBpY+4mxUGV6DdwnPB4DR2f179mgsvuGnyISUev7dtm?=
 =?us-ascii?Q?VT2Wdiobuz0CfUPR4Vc/SEgCteX03q/LdhTqlgQKIv3Yj5XZxRkw2eF9m/zM?=
 =?us-ascii?Q?GEh0CZhTcKrRDkoCYMfc1ITGmwYf9/fMzczU0PgD7hqsO/DSaJFEBXIdtvX4?=
 =?us-ascii?Q?dm5YVqbp4rGVf3Xuy2X5DyH0On0gKwekuyHsFzP2RnR0F6MROFHY7cXUDD1c?=
 =?us-ascii?Q?VtlYSdSd5gUk6cBxF5JPD5pS2S298iGXfb7yO1HSRvp652HFBATBYp6mKZt5?=
 =?us-ascii?Q?cvVYp++hS109gBy7SDHoPNOQtqKwaT6rSOfftVWvldDmLv282ZOc9esYLpjY?=
 =?us-ascii?Q?PBFVbe4dUWr6D8boaxs8xcF/q3d88GtQvdLZyLBAqO1cV7Kpa3yPjLTSlQ4n?=
 =?us-ascii?Q?J5PpoBjUOQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZhwLSpNWsP1uEmJqKhEITcIQv+GHudhP4x283qKX+QXDTj+SLGZa2pc4kTitGwXCvMfiSwy/U7EU+P8C4kPdF1BuPpbJFaT6YbCTqNXe/4eClaAsW7SYMqZZe30A3LJML9aqcpSo0FgQCMUDbMaJJhO5P1um8ocO4CmjEZBfKBmPZiTf1aaiS16ezgGPq6xQhDsjOKGh605SJpQbAH5C9Qg2U+LYR9Aid+jZ3cHCYS6GvhtYUilQDozEsCosQYl8WRtulyxZpCcoUwKOGRdZ00pNZWbKDfYTKqns9kttBlQ8zLXICyJSQrHXQ2LfWpk705AmswaGphO+DsNeU7tbbiWpXYETCu3/EUBzJmVw1DO7AbA0wrDN6/9x8bqf+ZFKW0zCQ3HBqsGG+Kz9/ottcHW8libGRef24PFTgfsaSpxwDhtZdzBYwo7Ng8LcMfPDI8Zm8uYxHhdHyqOPtwvrLw/auv16PfwsgmVFB4DY91x7UiGGSVPb2N2N0Xyk2upgJaHuxIHNtIN7CYsoNVd7Km4ZiAsE6WUvekKjC+I/ChgRbVhrVyG77g7sdUhIcMesTIVyyB4L+32WV64LZfu5n1ShDxiWrCmFrdaB1FnuTJ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4429278-9f4e-4d2a-2767-08de69e47449
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 03:11:45.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfLy59Y2hYGNJ0Yx11Z/X5gtFpMZMhBfivw/OU9EaDzsXOhIRe0ULtxyXR0evMp8LVxz+KNEH4LLANWTYvmjhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=749
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602120020
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=698d44f7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=iAtYw_wODpJ8HQQO04QA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: G6NjwHUPykAutHFrfgBmfJDhOm05P-qh
X-Proofpoint-GUID: G6NjwHUPykAutHFrfgBmfJDhOm05P-qh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDAyMCBTYWx0ZWRfX7IhBdz/stYpL
 0S/pYM3r6/ka6c8UuUsyD9H2XDXBJ0loZOFxM37lny/6IHrYe4MRffFvTBvCXQeHqX5Ha5LFyjI
 0v9D4Oy8rZBYcSGc2CqWB7tOPA566aN4/VcOTRpwWvxgT5eCEsSQF5Xk2S5fSdMGQ9LPWqTOLbp
 uN+E2pgU+TBnkuPD6b2NaEQxvkQTGS611MPGV6xKvP5vIpYvH6cu9mmEgtL/0WTfHDx8d6pgly6
 b2ITxaSVzPHNw2kSyFRoIKKE9loqIBrwgNAhGPKQadruyP9Q48AQhIlh5A0nNv4Xr7ImYyhQWBF
 q5PW7iI2blc/lyJk8H8ZRcRRuF42REN/lQIOXpB0PmeRwGOuEe3SJ6pcGaMiVJfF7kOWueDVNGD
 D8Ss0P3dXSECgnfxC2J408BJ0dWQyn5Is+MmwGLFXSqWdfFuNi30U4pX3//0uQzArqv0z1+OnVq
 Sd1IoumzlDmV+y/Vm3Q==
X-Rspamd-Queue-Id: 0975D10000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q6ma8r7hpmxdxgi3n8fmbr4jim7r6gmh
X-HE-Tag: 1770865914-179696
X-HE-Meta: U2FsdGVkX190OnZCm/OutlLE/THpoT6zk8UCt508MKtKhvc3mkXMLrgFVmLejc+XPgLb/KdoddB4neGsXnIjFj3gaoYduOswT9sh11lQOWhH7zLeqdaiLyHOGz7HKcckhDAlc5MyDSpLhVs09OfkezB0jPgL7kFvB0dKcCqyt7Jtl+77HWFlbxRHVoDHypeBves+geRiSPFtQkqpA9Vcuzf4+lZCSZK8d61TbFuC2fGSqV2i2FTEePnBk+qZ46Avp0fCRZWjRfh6Bvfjm1z42Sww1ujGQgRQqnQLhF+oRKlX+cAze8GbFVwFnIzVCucItfrj6cmXbyIICdipvtWKX5+Irmn5AdKL+zAvzGXXGxVUGcHig7EdnHDPrha6sJtUWdXKGV+8B/0XWXq3XlHfZRveNOWLhAJpPsS9e2272nAqkkmq8oYGvQXudgbyf/rnX7WEFYZMQFUX7roh9kgSVbggDnko0sMBBsWmy6p3qZYDtnYEdo8NHWFl0NbBvFhCnAeKpLyLRgQopUh/yoBid7lccJO+rNvm/EK2QYz694q8Bp84p6f0SLvf7nbB+e2VcwwSFBCQ+foNRToxnSHX1xxsBoru/BBgdJbFav21FNgqW+B5RqxRR3seTfFkY8veqOcIOQLyVP27JAVT0+Uwg2SE6mqLr6toA3sLsxI4DV81V4OKT7MGtMj9wBdKdgAhHz2F7Ultmx59eJT2b95GfG4ALMOuHW5oP9u8EbZ3BRYqXupZy1tHqCPeExdqsC7Ojvalz9rx2s3wxY5gWn2mMnuO5GWGGodcYaFACVg9iMqOfNKZ/I7HNKa5Wd1H3HBIdM7HgHQ1/95bpJe/QNy/mgQWU8q9YKpMvkCBTEMPx7TWErVwa9mvsTtcoBlXLsQxH94vqB7mYmXjDTg08wOFDVl4y+NC7nDf7xhJ+uZYhmuWoVFmU6Zsm6MFpN7bvqcH8el8VtARsK6bOHvyi3y
 A5JPEKd2
 qB6Fid1372c5gRJ2t05Ge91vIlAZbkR5LuQ9JRlyccn4n1WFr+5ITtu2Sa/GbhbdQ3jvDFKxAxp4W88GPS8t6V/NWCq6Blwi+jnlMeeL9IXn07jabAh7ItnJsyjOQHR/CvMBsKrEwfQLuv67WDSBh+wyUO4ivHylV/rP+H5f2sOofl81RaXp/vrfYHTO/wRy+bwliBvYY2p36W1lIKvbvt8X7q96ywrIa8pr7op5iynwzjNESFgjJ1AbkgQnu0svUR4UoS3lw2q4+Yv2NCawQqG56TQhjlWYRWqe+0VMToWeI3XB5PRDAPIvZl83MSzgScWHjCmyqDALu35+2qFYVWh8+Ir5IZhOXwoCsdRhfjbN9oYHBiMareZICJtymSQY1ltBAbPvj6ggycC6P+Jt81qcQZpLtJH3AMS8n/OXPb2vbDF374/yPKr6C+hfIzpJtq9n4YqquG/5ReZ+H54kQQL1Xlif2f9qzLcxARx9V5xQTOpKCELVsqKTE5qZ2U9zlmvu+7GSVyBtpn/jiIpcraug+AfeIsLJTtqOFoMTXSIfg/zNf6m67qaKXTlis9JZvyU70YIpHlhzgRfJcPNww/gMkx3P9XsyibU+re/FUk89BHcBCBKDNHg95i/rJ59BN8STdNGXMG2bBN0z3LO6W3TW0Wk+a+n2kU3QqHkD67hzCorkkqnKJAZH6UgTxueTpzqz2umKHRSOc94w1WZoOrtr8UZMgOuKNJJMQN9PohnDH3sj5K/2HeoptRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 10:42:30AM +0100, Vlastimil Babka wrote:
> sheaf_flush_main() can be called from __pcs_replace_full_main() where
> the trylock can in theory fail, and pcs_flush_all() where it's not
> expected to and it would be actually a problem if it failed and left the
> main sheaf not flushed.
> 
> To make this explicit, split the function into sheaf_flush_main() (using
> local_lock()) and sheaf_try_flush_main() (using local_trylock()) where
> both call __sheaf_flush_main_batch() to flush a single batch of objects.
> This will allow lockdep to verify our assumptions.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

