Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21359D2D8EF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D906B008A; Tue, 27 Jan 2026 05:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715A56B008C; Tue, 27 Jan 2026 05:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7E96B0092; Tue, 27 Jan 2026 05:32:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA336B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:32:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0254E140AD4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:30 +0000 (UTC)
X-FDA: 84377379702.12.5C0A822
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 83F941C0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MLa8VCCC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BLQIuzTz;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFJgbbY/VLrhmAYk5/xsKnKIKL3HCpOq52g4Q6B5ZzI=;
	b=x/m8NFtsQFIvyMTOIjm5anN0vMZMozFRJ/7YuqFaiJ+rYSP+gICfhbWnZMVo2sAcjLR/pR
	J/mn2vwy/3fiNrWgnI43+HmyPK1NJEd3zbtx2/tjGwnQNOTVgzIpalA30JBAT7vJj8rYCo
	OlCycxyi0KopaCUuOrCn55KD7Rc+Qec=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MLa8VCCC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BLQIuzTz;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769509947; a=rsa-sha256;
	cv=pass;
	b=aPLggWppMIv1JaKjMuSfr/T60L/HF9rmyYk/I3u9+CHnpdENi/bTeWRbXoQXEcreyUgSoO
	uMBn0SVjIshst8iJchsw2lJgSzIVPGKU3kPsBrFPNUBAvx5WxNqXHfb37GqsPbvJz/LBW1
	AErtXuP3BPh6b7KxFoMnE73rkjRa6/I=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QMdEJ1078861;
	Tue, 27 Jan 2026 10:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dFJgbbY/VLrhmAYk5/xsKnKIKL3HCpOq52g4Q6B5ZzI=; b=
	MLa8VCCCXFHX47DXA0wRH99pFQE6A+yf0orIR4znVwt41GJYdHnuMgGnS5r3v6X4
	oxk6QeIp8/XLtzpQSMti7ptLkAMYDF6cxI3eqEc2p9CYbx7r1S7h8lnaa9IZ4Ptu
	K3W5rNYNMQhbBhpxeLlQ6n1a8hi6UHJOOS3KDrOB/l1rgiePydR60Z35eFWnkGbd
	GfQ63JdfnHEbL3pOLhoOGyPEy1QK3rzSp8CHJeTAKt4u9VqJyIU5zjnUjQwE7BgX
	jk5Z3eisKvqIKW2DYfSPqc55OIMNaClWdn7dJbntjDxWthKnWcxGGrI3h/M7+joc
	qYH1U+iA786dgx/hWAZcpQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09kteh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:32:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60R9DZOG035094;
	Tue, 27 Jan 2026 10:32:12 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh97afm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:32:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVWI1WdLi63Q54N/DVLADe69p+25nmTIDa5PqNhkQiLfVqKlNhuiBjHIWNF1AAzTnymCQ9V+auOG5XdN+tHq225+3kpQ0OdrJHRsiYQZvW3LzWCmu08NdI2MXQixqsSbgSH0mqpX0WbWl1itbiHj+IXrGsPkcmyFPdDNiRLdP1zsoueWYFaPrtGwIzqab4ETNpnAS3Oa/y1J4Cnf027cQHpuO8xSMtA4G0Puz2WltJQ1Ow7n6sGC65OCkQPxBixb1dH0eF6lrYsfBleugWGc9Lqx/j9jTHpjkqUYc2ahYd9VjJW7/rgo9+8CKAWIRaW1E/1ir1P+rMWAklYFvv9myQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFJgbbY/VLrhmAYk5/xsKnKIKL3HCpOq52g4Q6B5ZzI=;
 b=GYbkrZ/im9AijxjgJtFCetuGkls44cG0JIs8Hi53XGkz54dBDxDrMcgvd6h/JH6xU77yEJZaQ2r6TUNRuo3x18k4ka8OIlYE897MKRnJJWP0C98I1JCocI/UZ0evIGIfmrdf6VwJaRpnVh3oEIv1e8y58DYBILV88D5Uhymci0pKX6rgxqyn7i8/kxnWj2F3DIIL+E3aEvnPprHkYvsl7zraBRBRvaYqIjUZbfbuyc/gntIxa3Cmu9fhLR2zNayhz/tm270B5ElPsWAO0Cdax2us+GfT/+sklfPvNG1wxrqiHgyj6+R74SSVYez2C9/EoYqg1MwPHorjeYfdc0GcHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFJgbbY/VLrhmAYk5/xsKnKIKL3HCpOq52g4Q6B5ZzI=;
 b=BLQIuzTzP/VkO7wmAdu7c1V/PRuRONBuFJwDCpuiIXEjbxnPFRng6x/Xzf7vTDQbOmFrRRQ73xhyvXpF5KoIeu3fAcvBjeceWMgRBUlf2D2bowppJUzlP51l6noPG7Fl7OXFY/x8Qrtv6nOFrbtYt+J85YZ4czXV47K2sjjXgQc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Tue, 27 Jan
 2026 10:32:09 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 10:32:09 +0000
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
Subject: [PATCH V1 2/2] mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable caches
Date: Tue, 27 Jan 2026 19:31:51 +0900
Message-ID: <20260127103151.21883-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260127103151.21883-1-harry.yoo@oracle.com>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0004.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 36cbe56e-cbf0-46ad-5842-08de5d8f530d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HyE2i9qIqMU25rh0diLbSVYdePo6lm7JwiKTgYBpOpqqAT7a0c4tQ+o/RNrL?=
 =?us-ascii?Q?ITARKXShdGvneCVL0n7jxS1XsBmWE/eh7Xnl7oE/iMbf4DMAC3s3kWAHDPFl?=
 =?us-ascii?Q?ISUx9g4oGI3b4y7OrNCq+wdDv9krt+0bqCOjRyCEihDvxohYuMRMmUjbwxmX?=
 =?us-ascii?Q?hb6MkoDd7sXEs7io+jGfKFzED32rCXrLfAtbPBBgVu77iZgjR1JmTee1U99B?=
 =?us-ascii?Q?SDqtIhufBDzriaDYpgRgExbHuNdGPq+2yuV8Pj9Z8GXwoK0tNY7CqWbj9nCq?=
 =?us-ascii?Q?QvUF69M5Ingu4D/7samapdtJzGcfmyt4w5mq2yVPDHXTki2RXVA5raAYccjo?=
 =?us-ascii?Q?i6qWeCZLcizWhGXaITgz4TvnpeBxJwpjRTuWpfh2b62/BFP1hYl2w3wjQT49?=
 =?us-ascii?Q?JzZiwfh1o9GB0MDv5mTE5DdbW5u5QMQJCu8sYnwspbCeGqHqJowV1HRBjC/g?=
 =?us-ascii?Q?b8ZLLIGnrm+K49N8vkANNWefzGgubQYuojrlHfZKjTz6d3a3lDjTuY0DWDeb?=
 =?us-ascii?Q?HkklHd6K5DWIxvAis7Oz7Cii+bb9xMdctqVsp3KybgBZU3EWhqp5RSwhvXDo?=
 =?us-ascii?Q?LYqj+ItkWgNLplkoquIYW3sBUb/Tf2POwJtI6SHd9FOAA//Tq8oAn5POyp4R?=
 =?us-ascii?Q?jfCDAscYcMFm7LrDttF8kh9W7vL2Ts5lTah6IPcRVdkL/Kn7AkjMGnESVUuo?=
 =?us-ascii?Q?Eh43dURvQcVpDI8x2iS76mpeQ/13uzQDc+GQInxlW2e3ZwV8CVaHL3wLwgom?=
 =?us-ascii?Q?BPfLGE7X/cpdiip77xP7YMBqtgMzNJHN1QWlI42aUnDkLDCVYjrZTE5LQjNj?=
 =?us-ascii?Q?C4gD4NxAGuQ7z/LHenNE7m48qgIDk+h3pk4gxRQfxt7j1D0i+rpcxnYgHEE4?=
 =?us-ascii?Q?8mDTa7DKgXOol2gapvquwz7DDOvD+7WBRfcEG1Ko2Fl8f4BtqK4u+HCVZzHu?=
 =?us-ascii?Q?9LccYoWWfUXwAHt8hMaoh3duKYwK+GcPPp+c0A58AMGHAU38A/jrfYnU2TXd?=
 =?us-ascii?Q?rkrlf+TrrUrd3AWC4vscztVsy+UToDA6FAYAk/8g6yNvyDALkBOO2DaI9SK+?=
 =?us-ascii?Q?HRSuJoOVV6OD+uVOzlKopIXKpynYk7X8N8AuMjCVfyjatSK6zfuJiTQ2d/4k?=
 =?us-ascii?Q?jknb9y+I9wKL/JqHanEv7ytC6eIarVe92BUO+K+0uXFE93LhpgYEiKZ+fFdV?=
 =?us-ascii?Q?jaCBpeG+WyBhqLZ7yEDnAq46wTvwhOjlUmWbqiS31pCedr9ANS6dn8+1xhtz?=
 =?us-ascii?Q?9npGitZUqx+KNDHJ5mdBIK7ZpPLQXPHIsOXmqFrNfK4U69C/BIqWDIZfs73m?=
 =?us-ascii?Q?O5IjppFUug78up09K0bN2dU8BEuazWhFPDmKxfABZHED6S+X9Ax25sYI7QSB?=
 =?us-ascii?Q?XDfacvr2QzW7J1PVcW+gWvE9Yhg5VXTouXptKNlH3iu2zVcRq+Y2Xmw0KaWc?=
 =?us-ascii?Q?Mw/+LGOk7wy36OawNQYLer7IUQzCYdteB7yQLzD8T0bA5uFluAIvG4GRgHAl?=
 =?us-ascii?Q?muKuSvXRmK+zdM1e6Odw5zoN4pvR/H9J9WMS8jpCfDnGQl+CPOmCXs+0r74D?=
 =?us-ascii?Q?l9iwDRX62azc5nv+rUk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SLhs8JZs1hpAi2yNABfQsLrtxcsOxprNhW8EDgHJPExOKtY2ZHBJuDa+mkUt?=
 =?us-ascii?Q?MFFcD6ICqVaLHBR+OlQ+KufHsrCMBB33jcWweLSs3Y8pukLBPcsw0BT2xLDw?=
 =?us-ascii?Q?kF9CdnZgnGZVzRtHP+BO2fDuhufqUls6kh5z1meG2P5QmRF+H8PkMPANeWDS?=
 =?us-ascii?Q?WiGCjMscrqgMTlQlfDmpyUscKVy6WUotsr2qjYblr9XqkftmMSetsU+XEZen?=
 =?us-ascii?Q?17B9Vgg/wXkfqR/Sy5pzIFJCxr4TGzM7MXhUfPfWXjCBwleYBjLZgKXKzSHS?=
 =?us-ascii?Q?4jf9QclDlTGoDk8jcPmaRX3gC8Iugpx+/+HW1WSXqs8qmjn4IIaIkuKck7OX?=
 =?us-ascii?Q?HKT5e+VqdxcBrEeeG7dGxwlPjHHEkrK2qJYEVRw2sgwiJpnfBJ1BTODDXTxD?=
 =?us-ascii?Q?YCFoXh6FEZg5jce5QLUf5yy+3IdgzFl4C99J0nlKId/ABag2fEW4trlf0+gG?=
 =?us-ascii?Q?6imNFSEfWwdmGFaeXHJZLe8/CFurQQFqErV5onKid9fhXpwhBrUSslIMccx3?=
 =?us-ascii?Q?TQxK96xQQGanuiTufv33TqWZGWF37Ii2hxvdtK+bIjqQMaTD0yfM1HXevc8j?=
 =?us-ascii?Q?c9NPVdg98HR7S7nCqhlcGMEq+VAN+TpPw5uVZB7ww3pSNWPj6ts6MxPJJY5u?=
 =?us-ascii?Q?6kBk67JWvxkhFjLbzuljcX8QWYI6+oYzQZkEkndnMxCrdBbyUVqrhoMjVaey?=
 =?us-ascii?Q?GC9sCLj4c7G8oQNhrlXcJBKhaWjkj6E63/J4NGLPD3abskmi7Jr7iTNno1uE?=
 =?us-ascii?Q?rLi2QEy2c3SLZGpBbxLXe8uO+MaHlodsaLyw40YSeSCEwQaFrTQtd4KjywEC?=
 =?us-ascii?Q?94pccNpFQi5BZZaXigjg6Gqdg8IyZey9EYYBkIpciTPJIa7hOl2PF9k5KUA6?=
 =?us-ascii?Q?yao1ngCL+YOD56P6zu1+xVwjpyH7zpKGo6lfYhf8MYOYua9Iq7ufe6J+XsxH?=
 =?us-ascii?Q?bmkvabGimHvK06/3TYKNsNCUiiNOORlw1fg/XFZs2lstEBWkmvZsYL0K1yZb?=
 =?us-ascii?Q?93paQ9goalIgI9NU6pxWb2T/Y/3GlUEpPckhCXUw0AlyragC+K/f115mnPlr?=
 =?us-ascii?Q?SpzG1lUrBmDwzGHMGfzR6KpTP/APzhyyoq5rhu1SU+foKJ0lto0pcktY3Kb+?=
 =?us-ascii?Q?XRrlVaXpD7bJO2twXt42P6XAC9mjq61igxdmCqTAqVI5upEpLip878H8liH8?=
 =?us-ascii?Q?2sfJmR0GtWfeP5E0ZsY/Cb6YrjeaY9LJbcLRJn4rULnBxpD5PKC/J8W555Mg?=
 =?us-ascii?Q?A0GMm13rq1QeLNTq6h+R3IZXggJjeaGt8sgNNFbhvw2gkceFcMXn1IZeGLBt?=
 =?us-ascii?Q?2fw5tlAvWKF5Osi/py0+Gnd1Fnk5BIvVg3rTZ2jhv0TIHUvFBq9mJy1oQCnR?=
 =?us-ascii?Q?kWC2KakFu6xnL8zaUQvTSav4MsvXi31q/kGrIzZw3XZCv4Mw3cGcMMs8htxM?=
 =?us-ascii?Q?WHZcKcadSKxAwKKFY8kfP/2nujCf7HEsTGU+iIJhZbcpy92/9ZS2pVXX/XZD?=
 =?us-ascii?Q?paYTx/qSWmh5naTKLZfNjr7M/b7T/YcKWsoRtfmB/VMEX3soTRaOgyAUggbf?=
 =?us-ascii?Q?GBmp+7fCg3KqR/vvQdtPooQnazBScJEmG/fUPwNRDrIgQGt61cP/MAyYqljq?=
 =?us-ascii?Q?ClXgjzJk5cvcOOYvwUKF5Gb427tW1wC9OHQ/1h0NgTdr5CxpXMet6H4JIBYz?=
 =?us-ascii?Q?WzffsyO1eXEqEL5N7C852/n91aLwnEVPyqmGZu2XBjUsQqAUF6lBCyeGVa0c?=
 =?us-ascii?Q?8VqmndqxgQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4ZistN1W5Bi27CIbb6ObUQkD31Xmp+vT1beVTjJGQphaquQSPQBwFWj0xdRKibkxiPfhkBibQXTZuN9+flBctAE9erH/UbN/DrlVgXZIjGOhNPlm/zYwWOkAR0tH9JjhaBWpRSK6P/jkzNcIBdx2HvTPDGl5XwgeTWh9pA19FmDVjd+MFtvGug2RnE1r9Xk47Wx1i2ODLGAUa/VbtxVNxUvrWU8n+DUjLFlWJhZ2XXbENIXsDOnU//6QGQpCo9EuqMDpOzaXqb53nySRfxaCMLOIiHXlHgtjDB7DiKq9UbZgGxaWpnto9BZX295vpJwh4hyKb1MxO6X8Cl/MAJ4nYZ3gk4amiNjDuetdSPYFfAfWyP6DqfvgEbQPsOUiMvAS8FbMwx1jl7SpssfcbedNpv9a3NTPwvEbOQE5aBdzhwh1goY0OruZGD2FZTdyr2vE+LS5eC23a+vobt6fqzt+A57VAU2jh7AIIeS0fMmKp840OLfipkYodkaZDivuHWWVNp92pi4WHxFK3s+ALxiRiVCALukLsjSOKgGDMh/3E9WiK//kBWcb+kp651QPgUAj0vwLhK++9vojz8fEtd5D1ZD+i2uBshhTBEdjPNFsZ6g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36cbe56e-cbf0-46ad-5842-08de5d8f530d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:32:08.9505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b0Lrc90MAEly3gz6uxHwpQuHe/PnfVazARzrbRGvLf2ILJq0Ftz0pZPk0B5UeMLds2v1s/fkoRAMLs3pV7QALQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_02,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA4NiBTYWx0ZWRfXyAJLhKxfOtmV
 tWYosLFpJBpyafyrmuu210pnaC+tDgZOhZEHGsvZOxBeO2/mX708aWh3bAP7h9LKOyvm5oeKw+p
 oG0h1WMVahYo5ZakLgIJ0osVxU/vGLEL0Rr4OpgaeI0HRFMDhWdTYRLa22TO2oIJdQutAP17VR4
 AHdUlrOXsp6r7nz6dN3H+QaPPn0uMKjrO5n6T2fYqoE1nHyLKiM6gq1rt6p2SB1+59QSbDJyyCA
 ErrZsATdYb1k2y67lFClZItjSXM2ExknMQJTjq5JZtD+biiHFVgfpM+sFri1K9YKPnpHlpCW6NC
 7aHobsDocdM8Z5eLv2ybaHlNwdHHwNSX6p2ca0rJw031wcw8c8vL4M0l/a/1Wi4m3TFgexjsGBb
 AkPPd+fii5n/i56QJwBGzm4GfOaJ+ysiNbwLlXFQATmiy+J0QaU6LhDK0olptDrMw5iWhw8pKYm
 SixE2pJCFK/kI75Fn9Q==
X-Proofpoint-ORIG-GUID: iIAdwdURCwyHGwCz61Jt4z3_IV8_dsTj
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=6978942d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=8SA3zXiRM8DQ6KTLXMQA:9
X-Proofpoint-GUID: iIAdwdURCwyHGwCz61Jt4z3_IV8_dsTj
X-Stat-Signature: a1i47oxubtkat18w3ns4795wdht5qhnq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83F941C0008
X-HE-Tag: 1769509947-912289
X-HE-Meta: U2FsdGVkX18e4nBmihDFRQEfLG20IQPPkyetlBFzh3RL/cbE/5AEbfHKJUnIhhH6hFUe8wJGNt6BAqAJp/1ywJxwrm4XJHyE5Ep3cJOZyn7kTFdYw2pN1Z2xr9qRJXEIEF7/rJES3JqRMG4wZ28GP+IPrh/kdF9oWxjV/UaSUg8uBGR1c1QPm/P1vg5kc55M1JlW0MHQm8DScV8p+UygAcjPjh/CPGluEcewHjpyQkrp5ZytBw0gYtRZ0Qdt5cFtuz6Brwl4/nsGP88GySQP+m62XCFR77thmXIV+q48s0VmpEdguIdv+yPoPqaAisxJ6Mu6xODO8WTVW0K/kofxWkRkE0GAGf/ZPnRbpU7S9nxXE71rmudGDjgtpJbYIG433JT6idZGRq+A8oeSRTGuOcz1P0DDwebfArAlyl45KWQprrFm4wy/sWmEv8eVQMD04855xTl6VZ4bu3is2K7HeBfsbwvCEuzcX65I/iurM39oFzpHaKs1GrybzfT50eg3nfvUK3ruccfCJx05Cc3DUdLsd9qVV3UBNqivkgafqS7ZyaOrZ+CIt6GGvHFruyT7RjDwzegVP/w1jEkVojL2LTjM/xcb+uAMQ3taz8nFGvBRMh4i6bPojhAflLfNBhnxebFKYDYmNtOzSpUztR2ckEyoMma4DTjbZmP7mk1l58tlUXL5G/tfPXmSaC79ph0TKQLBuCYLCKgZAXWWfNECT1Ut+WsRkwR1NiYPRCT/Mp3VLXz5MK8BZWtzCl9iv3JMH82L4TcbFfhNO9Dq1SGPBrANaSeN5/xTgHCQ5zp7elmUYtJMtQ0xLyoE3SWsbw+3a6L9THFnEqmkbGkX8wor7T9+mRA0WQIZCQqyyaTDe22U8ayLM6UIFG70WuUGckBTxCr11Qrl9tkN8nhGAtxKHbjoowhDMnXEEEbHBrJttSwcYv4z/0mHDXeetc7ZvsHkvAgRHqCOKPYORMn6rmc
 GzpR/zt4
 Wz7KxdWat1W0rrc57VZaL/GmHPDOTazrzTcqtACqTyWHtuQaYo0XgS9m1WMh8DXRdvMdDW37wcBL4Hkyzs1Ib5I+Y66A9LAd9YsrwFRaG66bKFGpV0gLV4dyMJFXCE3QxyoDW0nMQOANSFoMIseeaNHrxI1tVIe6czBTrp18gXM5TYheb44ZPvmtY9qUHO0VeyuA7FHg+th5uwHeA7d2VamcShpJYoZySTSXftvgPaWKjukivl63jHf137NL3bJL/3Qg9+nLMYiZYt1/a1GgctE9duojVIsJEX6QLnvnc74VHlJPVEPXO5IxDMxXE3iIzC6NjbgUweULmNS6tHQjBLe6f8GGUILwEq3v1SrdgM/bXc2LK7eaV6F3yHKiSqn997cuHlzXYsRgTJ+OJ+BPGJw5waxn3VrNujFtf4g1zgDlQmnOzFQmNT3i/LChK54zWgaUscGZNPDcQi47qQA8efW0GrARICZOxW32okLyEVHXEmZ8e1Tmr3MLzDVxil13utb7a2dtLEPsKbFFP3uzVoltV35BPPLnS6IMeaI6SRcMExcK5sc4cr10bRU9IyGeHNd2pGQP9OFm09Xu4F6RiemkWeP5Q+YnKFcgylbbCjSKg9eQfWdbfcOAGfiHztIvZTWNvQOSfO/LRuXhrSEul7j+3keJSvOVvYtM/cMQGjHNFAL2lGpyTvzp3gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
slab objects, it prevents slab merging because merging can change
the metadata layout.

As pointed out Vlastimil Babka, disabling merging solely for this memory
optimization may not be a net win, because disabling slab merging tends
to increase overall memory usage.

Restrict SLAB_OBJ_EXT_IN_OBJ to caches that are already unmergeable for
other reasons (e.g., those with constructors or SLAB_TYPESAFE_BY_RCU).

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slab.h        | 1 +
 mm/slab_common.c | 3 +--
 mm/slub.c        | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8593c506cbf1..a5c4f981ee8b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -388,6 +388,7 @@ extern void create_boot_cache(struct kmem_cache *, const char *name,
 			unsigned int useroffset, unsigned int usersize);
 
 int slab_unmergeable(struct kmem_cache *s);
+bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags);
 
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 904414c3ebb8..d5a70a831a2a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -174,8 +174,7 @@ int slab_unmergeable(struct kmem_cache *s)
 	return 0;
 }
 
-static bool slab_args_unmergeable(struct kmem_cache_args *args,
-				  slab_flags_t flags)
+bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags)
 {
 	if (slab_nomerge)
 		return true;
diff --git a/mm/slub.c b/mm/slub.c
index ae9af184a18b..0581847e7dac 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7676,7 +7676,8 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	 */
 	aligned_size = ALIGN(size, s->align);
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
-	if (aligned_size - size >= sizeof(struct slabobj_ext))
+	if (slab_args_unmergeable(args, s->flags) &&
+			(aligned_size - size >= sizeof(struct slabobj_ext)))
 		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
 #endif
 	size = aligned_size;
-- 
2.43.0


