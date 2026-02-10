Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D49EA3F35
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 10:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD05C6B0005; Tue, 10 Feb 2026 05:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53E66B0088; Tue, 10 Feb 2026 05:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0CB6B0089; Tue, 10 Feb 2026 05:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76A506B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:33:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2729B13B114
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:33:17 +0000 (UTC)
X-FDA: 84428184834.25.D029E5E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABB381C0006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:33:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RF+FUa4M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Flr78xSO;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770719593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RabIK12CxUDEo+p1FGADTJzrHc0taQF6VMtTT1t0uQ=;
	b=8ONZQjJK2b0CynNEIXIvR667sdDRMZSvpRbH/5q1Elf5ms+vP9l/JJhUyY3VbR4RDCk9xO
	IRo5ccHmQhYUn1GVQ777RdXjXmfB3bVTZSaECevuBelvKvhQe7R8Yy+s+jm26uiEagTFdz
	Sr9toh39BXIHKI5gYHFWTJvnKRwpjmQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RF+FUa4M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Flr78xSO;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770719593; a=rsa-sha256;
	cv=pass;
	b=i723F81dWQTL5Vu8j2Z4C6HwW8rO7Lrv221nNiyFDI6/Dyzl7OVsTE/Ou8rqOoAKROm7NP
	yizPduQYGQsr1sm5RuNcsJxPjPi7dWs9HgEJthQSKAKzPVIy2Mcfg5fas9k/xsEmwtKVWe
	QsjlWFxEAgteVMf1NiDEISC7zU0XI7s=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9vHnn3608181;
	Tue, 10 Feb 2026 10:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8RabIK12CxUDEo+p1F
	GADTJzrHc0taQF6VMtTT1t0uQ=; b=RF+FUa4MrCISiLerL8gq11UUwbN9KvKIng
	gfXtR0hSy3OeWA8qXSaBUcVj+GMBBl0l/dfwKzAHOxQUl/3gMD63uEzLG0vOtZzw
	BG+gPM41HO1WUzk1nmqxiiEHT+fOekgfK/psYfCi7EzX7kaUxq4gJuyHcYhU0qyt
	mHOrCkFlG+KgwclnYxOLoMGXMdf8jbUjneifILlwL/HhauK5RWyLxIG75oxWAsp+
	pw8eWqU1gD2VT4spgaXS4/4k67GYtaBBbea6YZumy189ZAseGChvtzAzvkqaBOVc
	JxrFxr3emQHLjBkfPwVIjCO/qthRgXc8Gnurz9PWo2coh7bXuqdA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8ur4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 10:32:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AA1uq5013195;
	Tue, 10 Feb 2026 10:32:56 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010052.outbound.protection.outlook.com [52.101.56.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c826xjcqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 10:32:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QB0BvTghYFcwvvRS/kfHlo2R58Jfxdpe4YrdDOK3mUMqcvf8xArQUYKo9Ii5Uh+J1vgJrYlTzkP4Gnbsa1IZZ277AT2GBCIt8zPkHZK+nlozAqW/28OKULiS65HaAuBVjD6VyZzVUHtozxsRjCK0ciRnir7aVZ2sx5OeBgApeLZpwrSG0ZuFU5ePmPBPr8xUa300Eit0X7IqlCd4sZE6BNkz9X2uF1ZpygfNw9CAgvKWvalG1sRHq+qy6by9AnhUID6X0IQp1j3O4J6J7S02XxytXU0xyNzY74safhmt84B21Jd/LqSvS4lyRFw4Rh6zxmp2a3cxulRmHOcPxuFCrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RabIK12CxUDEo+p1FGADTJzrHc0taQF6VMtTT1t0uQ=;
 b=lRf4jwjLIg3HBhMM+duwDAkbYmpX5C2ahSaX2NEaM40ZdK5QRVFmsXODxNLjQ4fVYWlgMzxyCyCjzTCyTcQlQFG3RKFVnoSVLLuXs26F+qVk3EofGPlk3s83VLTkgCCPzGUKfBPAuPjiWACSfgHAN0eNgb5FoDF45Zq1e1UvspZ9Gzkp2+9eW7QnpbJHA7x+GpF41/wkuI6eNysD/1kqsKIJ8rIjijomw5mnVUa+LlQtNi6FlPEceL554kR6A01irPfs0pIClzP7hu6RrzhRIbVY+HD++R1xFC+awWE/kpMpMVe4V38pCiYJtet2GvfzAY13CYr+PSvIQeNcOjv3pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RabIK12CxUDEo+p1FGADTJzrHc0taQF6VMtTT1t0uQ=;
 b=Flr78xSOgBYp4EfG2w3i7LIIP2Fq4qqtfdsYMK1qvM3Vl9Pa0BJ5WEkWIlMgc3jGNNB6E4T/uobCFu6oiKhv1/eSl5FVEzd4tuDp0WZ1MoCivWxjWuFFfltLNN46WRKiEiTB76SN7L7aNRuWCigRUOUeUtQN+o32QJUpdiWLZGA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB5844.namprd10.prod.outlook.com (2603:10b6:806:22b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 10:32:53 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 10:32:53 +0000
Date: Tue, 10 Feb 2026 19:32:45 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH V2 2/2] mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from
 enum objext_flags
Message-ID: <aYsJTWFQrDcCVsuX@hyeyoo>
References: <20260210044642.139482-1-harry.yoo@oracle.com>
 <20260210044642.139482-3-harry.yoo@oracle.com>
 <ym376ht2w32x3zmfpteiezo6goelaiokvk6ujgp4imdwpw6o2s@tz2f5hvm3ezs>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ym376ht2w32x3zmfpteiezo6goelaiokvk6ujgp4imdwpw6o2s@tz2f5hvm3ezs>
X-ClientProxiedBy: SE2P216CA0053.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB5844:EE_
X-MS-Office365-Filtering-Correlation-Id: 9088f049-cb54-49d1-f3fb-08de688fbf53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rMHhmJF3U9NwrlvGlaXTDgcxnuwLRojnLvxb7rAwyyeeJqJ6d4iCsqTeeBsK?=
 =?us-ascii?Q?9f18IlGpJ6XJKNhESjvdr1qZ5G71TzFhWSHn4cLzJCJrByZyL9nuN7uRROJp?=
 =?us-ascii?Q?sPwwUioEQe9sq3uQbkm9wm9p01c4hhoBLYDpwTWWW7Co/JIhPcHqSGlopp2V?=
 =?us-ascii?Q?dgkD+v2BET0UKBNEKUSEdV/v9vacvbphpjcLF3aTuVCyw1LHOGww6dSByP+v?=
 =?us-ascii?Q?nc1SIC1DW8BlzkIkgOpPwjOAy5MQbHBb0LkW8oP20GboGvii+b9+o8kP6fc7?=
 =?us-ascii?Q?eGdfMFWCrNbHVV8zQodtl3AW895DOFs9jDW+4WErW7NyGihPQODXB5SKGUov?=
 =?us-ascii?Q?eWACnDdW30OmJXBnXxt6XPVPeiG8SRbQHblyOinCQI4GOXHtOE+RsLzEfcMg?=
 =?us-ascii?Q?Fvfq5hxWxd2ZN2R8Kx1v//2FUVZhAqaGOvMKGtSh5qQ1SehLrab0RzQ3A4Gr?=
 =?us-ascii?Q?hoZf8j1XAa25ZLpDpP8xSOpdysePYseJNcAatUHHXdSM6e+E8GMrw6SLNJeS?=
 =?us-ascii?Q?KwYNr2dgrU8squEuCRYDGKWm5+MOPt0lfPEwT4h8jUejRWHK6JuYblQ4jJim?=
 =?us-ascii?Q?ww6d52wudTBLb0jbVCNf4mSdrNcbxjzUmmh3ng4Pt1vRiTfLUgvaqFkQ3X5t?=
 =?us-ascii?Q?qj5Wb7IzVRxaL+p5gH8nXP1LbVK+Stjqb69oh8H2ne8MrL0LlVeRGYyePPzs?=
 =?us-ascii?Q?xhVgr9pSwONxHFTpXCza0vFcNUnFDC4iQBGZg475n8YgKPcsPOvySAMHv/dA?=
 =?us-ascii?Q?scW0LPUdOjeDduHreO2J1iZ2l7izq0RxjwjYVEl7eHL80mbpmHko6D1biD0E?=
 =?us-ascii?Q?NX229wcRlOZaM4ICfy9uFJ365InichIx3hNr5mMcT76x99YHNmggVxOknxT7?=
 =?us-ascii?Q?72SpivtCBu5O93yqPh0erJufGM88Bbu1O022S30etyPSck6QFyt3LdR4RA1H?=
 =?us-ascii?Q?QmAImytNo3G8cFZJqJ8TE0fJYjfnm2IdIhH9ZE3p7cfEb8Tf3dZpH+tWp1IE?=
 =?us-ascii?Q?ZbT65NvPi+xonAzWHs6Olrm5v9Yi5RKji5kTOvTJziKOzLbkgqH7jWiyrrZ9?=
 =?us-ascii?Q?tEMpXZatjaNrx/JQU7rI48j4afAaNQz2HiIGNCE137RGyXlcJF06cQctig0+?=
 =?us-ascii?Q?bC0XaEHc/1jMazjeI+m3sWWmPVgh/HmapLHXzeac8ys46nu5vrUD3DFPbsMw?=
 =?us-ascii?Q?1TMhrs/v/Qtpbg8y9uXvVOiuWzbTPTVvwhQlwj9wXQaa14mToIz2iP1hbLXs?=
 =?us-ascii?Q?myH2gS86HZsgLqPyye5qa8DxJphPErFMqtvrZSX/uiHHvNn1Vk2j01sUvOzF?=
 =?us-ascii?Q?c3gpC5Dmo4TjQLsvQJIgGurg2A1WAvHfA2zBxQfL0HYFDdtY7RBDTaeeWeeI?=
 =?us-ascii?Q?H7s6HOJcLUveNQIxIEUCg3kt4kUc+axNRGXJd+qg9pLxLLsu/AwgOV675VPr?=
 =?us-ascii?Q?m0slhYYTI/9gn1u7mWDNqOuV+QE1PKeZbQVrxDv5fftulS3nhIi91qNjDZW6?=
 =?us-ascii?Q?34gJ6Ug52gxm5ao0i6kmFEIbqRAK+VHzXbb9m5tUJhaOHCph/4O5SMhK8eP3?=
 =?us-ascii?Q?EbhuNOFf79trhOPp0fI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pTnb9IuwjgEZ2DB2fdLwhNgC3MbCiIoEVWRWSofIKMoLkjQvuZ8Gjtn1GnHm?=
 =?us-ascii?Q?3sXrhsga8EYtTumpUIe8BbPe4kXCsBitgzmM8iO/5b3ODdMbczox4ON8zAk0?=
 =?us-ascii?Q?zCTevJXlCUkuU67ZRnDBzpT/OZjTerin+QcDmQW9JzTsLPUzWcl/ckT0gFgC?=
 =?us-ascii?Q?ZvbGvbj5tsNIO7v7WRAlPuvv36FHojfWsiYaDYqE3MWU/g15M3kD8J2C2pSY?=
 =?us-ascii?Q?Wl6F+iiWV1W+YiryAXrpEdeZ8+1+utkaZsGvU54g9BGbfCvDTbHWvtG6/1TQ?=
 =?us-ascii?Q?8UJ71Nvm2yOuVXARvbSTbGg9gg6zek+TEXITwt46ehE+pxYMkG+5waXswsDr?=
 =?us-ascii?Q?bwgBb3k0NiMSVO9uQLnLfQYlCQreLr8XQBgl/ofBmAVkJR2osn/lKFzg2S7P?=
 =?us-ascii?Q?keixApAXqZremVO6eCn+GE1qdF3Yp4r7GnSbY4aajE+IR1ZJNPFljG1biFc+?=
 =?us-ascii?Q?lFuvRkU/etfwuy67YlqWzqaqQTqRKSYejRGuaZsRapluPH/NdttXJxOrdn6f?=
 =?us-ascii?Q?dgEWOm9/g/3Il/sZ7iMzEeearp6fTGuTKiNBoew6kCG+YKi/A5xoytiY+Yxg?=
 =?us-ascii?Q?sW4Nd5UYsYvRTJmwjpf1HieGqLE9UGSiZDBLuT6hQRJyvBBTWtS2/GW7rqjv?=
 =?us-ascii?Q?tPCfkN5HpJWNdWsRzkcP0IZ9V2sUzSnoR+yE7qpwmrzoOe8+2ExTjXxzLCse?=
 =?us-ascii?Q?5grV+pbt/TjA4fD3DihU56nEIqKwANPCqjzYefn83hW28LU77d2hvsi6r8B6?=
 =?us-ascii?Q?46e+Zi7vvKyKgPJP6yS6S2SETDVSlMfVcRZiY7maWXk3K+WCzOgjxic0iym5?=
 =?us-ascii?Q?Npvqdnl/8e41Ca1pqY4VlZk044iN6ucEvYTPJ85O78g7ws5JCDqHSCFm5T4s?=
 =?us-ascii?Q?px9yBP9KXkXppwXZk8vtEzl5akHPYzD/hPUhBEkVUl95cSu+quUpObU5spyU?=
 =?us-ascii?Q?mGTiU/pSuhDsOjylHdQ53dw49B4c8vO2yLJpRuVtlP4B/fok8lgVHBwLNYjw?=
 =?us-ascii?Q?MYovPvtV9JlvmN4xRz5LrjlNJ9ZEV5AGU57L3953yQv7UmPH+qToG6RhZkVZ?=
 =?us-ascii?Q?DlXTtj3Um7eiu1xdp4pCAwQ4JsyZobIHAMbhW6fJDjCEDZg0VI6/W3XRV0V2?=
 =?us-ascii?Q?p5PJBLBtkVw+oJPMNDX5+qrB1ptBWJmtj5DeuWQFrFlncFE7LQNteSBhZavi?=
 =?us-ascii?Q?IyZp9AVWOIVGNQFnvgdH5Ldf5xa4GJOhOQVxY2wxJvB/EAw5vqXc6zFbzLcn?=
 =?us-ascii?Q?D8l/10+5XxtZeQ+41ELbWOTAwJdvBMRwXraWIEgIubXnvTpAgztFtwyJ0gIR?=
 =?us-ascii?Q?Jpz/Iditbr4lYEUtjQwPZd8zhn1o0jqW87SxqFI4N7n9yoiF/B9aBRaURpTR?=
 =?us-ascii?Q?C5KZjzWk9UDoePTsO++ZwufyuVazYciQkwVKYjD0soxmZcwmnbc4RsEXOdcH?=
 =?us-ascii?Q?gofqwLYHAAy9uviHv1HMYSV8wxsNh/Jc9qOkGPjy5/5TqypJdSC8D7yIIDOr?=
 =?us-ascii?Q?TnponsmsVPtxnEuzFM50Th6cvR+qmP0MWeNCzJPy4EYmeO7o+GOPHZeFUETl?=
 =?us-ascii?Q?l4/USZWe4iFrnz3+Qcc2YkaliFSWv4pzNiP9lWwdbwyYgsTePBD+ETOVXU/G?=
 =?us-ascii?Q?K8x8pLmwD90l/u3T52q1f2KfdAKbY4c95FucD0O45gxGKlVjqNDrJ5nt//yU?=
 =?us-ascii?Q?s+2m6k62nFF9TpiLkPu0dbkOatQqb8OK2Iv8un6J6SSV8TqbKaKM0AN2iUJU?=
 =?us-ascii?Q?hU6y6/84Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZNv75SI8zu+QYBmy079zvXEf47z+w/y59jqkxgNP1JdzFFlzd+LPL6NPJ7RngYK96ZlcfcyEiHqiNJuN16RISA2BPCGq50RP8OdBZoPL8Ze4r+8M9xeJLhfuCoHxunwgwqbaQHUg+cLmH3hAb+9byxgqgSESuCOjPExpf+NkPKgzWSlH82h3E0Yxk1pWPcFOL70YhW0wmVgw1ZdjLU5UUsPFaip3rBfaec8FWXOdSzsMlAUBE8vxOktQAOoAha0lvegPl1KNJApSkDGGLy4U+Du93I6IKVBD9jTBaAP2d63Ughvguah6OV4ARLgiTZG3RuKtG9eRzVXBw1XF+jh7zkjR+04WkOl5/G+L2QH7g4BrPk/JnphhbtE67RAN6uH52JC4Ai6JgQ58e3i4nxQBJ5yVZFnd0XHuj3+jw1KtE6xPVyuKoUgVGjh6dszy+ZtvcNCCSrbRPwtYYKolHIprdJKVktN8Ok9qeSMSE3ys7RoZk+tBEw+geE+m49UyQmpQbD0KleHyorlqtf+nz3eFC+Yj5QOldmRu1hPz6mZAagAKzNuQ7REfFpQcJ8Izv6BhLcIy7OEfpGkEXxUoImhxC1n1hxwFhjUQ5fFeyoviJI0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9088f049-cb54-49d1-f3fb-08de688fbf53
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 10:32:53.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFXuxvgbUS2cmH9zA4XnSoACPOoqrmyoY9D/47UMPNsraXHW/oNB7H/7JSZkHNZSqAXC6ocVzLcxnaYtv91t2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5844
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100088
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=698b0959 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=qhPkHFQOtCETH79-tycA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13697
X-Proofpoint-ORIG-GUID: 7T3v5IwBAYQbSPPjs1tk21pNWB_-oDx7
X-Proofpoint-GUID: 7T3v5IwBAYQbSPPjs1tk21pNWB_-oDx7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA4OCBTYWx0ZWRfX7s9+4nhGkgOY
 M9Pp302LnHXtKo8Y3ZNPcJMoHAIHiZqO2pU1K4HNbwyCDxyd4UELusu08NzgLqe7mHENjay1+j8
 5R2b/i6xaikRtIR5Ah/2T/sK4tczJo7htnoITk4mH66pToL1lXjrEshPjyGHbVv8R9Yhc6k1Al7
 PBpeZ+ByDUIB0ZqideLgkCdm5fYZbatWqWKtPXNHPG/gNlJ8Ss37zNTGHRdAujsRkkbnpuJBtbO
 Ea9LjzFQx7mRJ3rEGmYLkdyayhon8ebFsdnm4gOPWVkdxkiQixH5lgNgSD0cmWeCZFyTD1FdlAZ
 R/ZxJgoY92t9QS6UVPER5pSSKplljw/+yNBHjLeOq7nSWsaQ2/+vWi0c6s4QaVOgSiUlGxOGKbh
 gPfsn5iZbgKIKDwpaRqHNbp+b9m1OwfdbqHucWweo18mDgtWRgFYixTADXMQx6gXv7jm0lzujfI
 Blplo5uUZKR3Ck0URAavXizRO6hhI6hU5EKH/X04=
X-Rspamd-Server: rspam12
X-Stat-Signature: 67cn1kxznp9iz4apdzt84ju8i1wnkrty
X-Rspamd-Queue-Id: ABB381C0006
X-Rspam-User: 
X-HE-Tag: 1770719593-995313
X-HE-Meta: U2FsdGVkX18USlHArRM84S571IK3GNS6OGJA3r2TtFrp74AUzY951IkWGDvKX22VyYLa8XIlZmJjr847tyqRCI0ZAr4MAkULy5wT0H+LVWFeSi5Utd4v43D6KW7f01FRT9+5gaA/9mcjeEeWQPlFrcNPt3qH2XhuGbNtAglskU5jNCK8PlvjlzJDgr4Hsxq0jEeqImR8n6SegckGM/XGF8JFSnc26G7jM/FWh7vxA/6jc2Pj3JOKBFp6EgxP2Am45aWWToFHyO5PgwS+MNuXw7MQxOOxMQJY/p/IgnQe8GTp6ifw3WXtOlfaz4xoU1KnYBNxmoDY0zHjwO8FcrsISoysk9aGRLjgeL+aVuUNbZ8IchzmXY8APHPmogKL9k+ZRX+nCCXbhSzkFPCcJhn03OsXB1Yiq7AdDvS4KMflYWsD9rhgGfijeLzDlkbDPEKPq5l9eunZvw7KllBjuO6RrOhgZiTP8utcZRGnzv4zqsPW0ODT5hNZU4FI5BGvqhohAWXlofMhAu3j52uvu8dK55b6JXT4QBmo1e1A/J972owlCHCzZ8g4bDJkCyw117toij8lPUc/tymzt0UgR8kaCPiOOZvqqOByhxGe2ba6C4qC4C4ISw3ivxrHoHkIwug3896VfcGkK+rKt/4tfYAVd7o+szHWP7IWGVDQxhf4B0Qw0caCDiz3nC8VTs7jDuuVoN9z6peoOeVVfvDIgtPLIiCWZ4MSLv3cYAqc7fdxaiN3zJVeqq1OKq+4tu/mBNP7D+wR91EiElrgYA254MDFeNc/D5jKZrSO4pZUbjpmH9SFziwYU0akTG8SbMTflYIHgsvbOB/RXGe2M6tHkY1BLt+MVNhIhQqEcK0CI6gXP0om2bpiek0Hc6kMDFDiNdirg4ApLoM4INAVyXEsMoRjL09cB6E1WwpuyCMZ6hP64bXxbgWXn00W3Uz4OKioxVrpCenpVdRl08blqk8ANOl
 J5wufXIM
 RKp5FHe5vmrx248oWNbxBMfAnixg4bOI9lCDb1ULAAb4ftozXrBrK/ieBh+lzJdfB2clQzOy86Xtez/IXiJTyOaS+U94NgBwprSdtjYgubRv3sOx1zkSd+BU3vn/YAimlSczx+fyZ82WmJ3AXr8L1baIYAhA463oSnvUDL8gqPTalqi/6jN0Um3Po0t9Zvn+TvPE0aPPxh8w/A8wwkAoeGmPtJAKEfU2/7tiQnLavEnMsHjMgqsjgSIWx4LMauhKn/FGcdntEBMog+ONtiv6EhEBTDNTq8GqHWhpfqeL8l5/OIC04aSlNE23HGalJdmPw2EBRFt5krbbPMmWb+Znnd4CYp+tc+gxRPY8bCH/mn/xQ81o9lqV9fJMyzPaMWm/vnaLg67VxK5/oF0q5REiQBRGRskGcxocBYKkyjqwFxF1IyhlhwBGWe03p9tY+yajsjCVVFKzA1Tz+oMTcs94M/EBYtpE3HeXcEbOtU5iAvgOPO9I7wRItvJrXlq8xouxyR7Cixafe7/+vcDv6O32vEmAspHQMTWLLYsVLflaBa/iVMaMx4YN2f5OtZ0tq2lRHy6nhJ/mmKArdsG4t0/roQzZQbOzLjKBNa35cAlSbG9ipov5hXGHle8R8wsnfW8o14bni9e5Sk2i3PFQIZJnI1CPL+bbqMilbK7n73lGE1Ia422TwVcIjZNGH1sUX2D0uF5X0Gzc2QEPCAmZrFW5C4AbYS4FMyhpU8r03Kn6P/Bhh45WXh7WJFUOrmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 04:57:42PM +0800, Hao Li wrote:
> On Tue, Feb 10, 2026 at 01:46:42PM +0900, Harry Yoo wrote:
> > OBJEXTS_NOSPIN_ALLOC was used to remember whether a slabobj_ext vector
> > was allocated via kmalloc_nolock(), so that free_slab_obj_exts() could
> > call kfree_nolock() instead of kfree().
> > 
> > Now that kfree() supports freeing kmalloc_nolock() objects, this flag is
> > no longer needed. Instead, pass the allow_spin parameter down to
> > free_slab_obj_exts() to determine whether kfree_nolock() or kfree()
> > should be called in the free path, and free one bit in
> > enum objext_flags.
> > 
> > Acked-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  include/linux/memcontrol.h |  3 +--
> >  mm/slub.c                  | 18 ++++++++----------
> >  2 files changed, 9 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 0651865a4564..bb789ec4a2a2 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -359,8 +359,7 @@ enum objext_flags {
> >  	 * MEMCG_DATA_OBJEXTS.
> >  	 */
> >  	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
> > -	/* slabobj_ext vector allocated with kmalloc_nolock() */
> > -	OBJEXTS_NOSPIN_ALLOC = __FIRST_OBJEXT_FLAG,
> > +	__OBJEXTS_FLAG_UNUSED = __FIRST_OBJEXT_FLAG,
> >  	/* the next bit after the last actual flag */
> >  	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
> >  };
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 63b03fd62ca7..a73a80b33ff9 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2189,8 +2189,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> >  			virt_to_slab(vec)->slab_cache == s);
> >  
> >  	new_exts = (unsigned long)vec;
> > -	if (unlikely(!allow_spin))
> > -		new_exts |= OBJEXTS_NOSPIN_ALLOC;
> >  #ifdef CONFIG_MEMCG
> >  	new_exts |= MEMCG_DATA_OBJEXTS;
> >  #endif
> > @@ -2228,7 +2226,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> >  	return 0;
> >  }
> >  
> > -static inline void free_slab_obj_exts(struct slab *slab)
> > +static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
> >  {
> >  	struct slabobj_ext *obj_exts;
> >  
> > @@ -2256,10 +2254,10 @@ static inline void free_slab_obj_exts(struct slab *slab)
> >  	 * the extension for obj_exts is expected to be NULL.
> >  	 */
> >  	mark_objexts_empty(obj_exts);
> > -	if (unlikely(READ_ONCE(slab->obj_exts) & OBJEXTS_NOSPIN_ALLOC))
> > -		kfree_nolock(obj_exts);
> > -	else
> > +	if (allow_spin)
> >  		kfree(obj_exts);
> > +	else
> > +		kfree_nolock(obj_exts);
> 
> Looks good to me.
> 
> One small observation from my side: at first glance I briefly wondered if we
> could ever allocate in an allow_spin=true context but free in an
> allow_spin=false context, potentially resulting in a kmalloc() -> kfree_nolock()
> mismatch.

Right, kmalloc() -> kfree_nolock() is not supported and must be avoided.

> After taking a closer look, the only case where "free_new_slab_nolock() -> ...
> -> free_slab_obj_exts()" runs with allow_spin=false is along the "___slab_alloc
> -> alloc_single_from_new_slab()/alloc_from_new_slab()" path.

Right, this is when trylock failed after allocating new slab.

> In that scenario, alloc_slab_obj_exts() is also called under allow_spin=false
> and uses kmalloc_nolock(), so the allocation/free paths remain consistent.
> So "kmalloc() -> kfree_nolock()" case can't happen,
> and the code looks solid to me!

Nice analysis, thanks!

Yeah, for this reason, we should not free slabs that are allocated
with allow_spin == true, when allow_spin is false.

kfree_nolock() avoids this by deferring frees in the slowpath.
If someone is tempated to rework kfree_nolock() slowpath, he or she
should be careful :)

> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks for review, Hao!

-- 
Cheers,
Harry / Hyeonggon

