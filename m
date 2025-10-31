Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DEECCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 13:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCCF8E0096; Fri, 31 Oct 2025 09:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC518E0042; Fri, 31 Oct 2025 09:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DA98E0096; Fri, 31 Oct 2025 09:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7E88E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:08:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 954401A04CA
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:08:44 +0000 (UTC)
X-FDA: 84058438968.28.1165B3E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id E70858000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:08:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ac/A8LEd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TeY0eEJb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761916121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=by0mBeTQEMFBznlAGowLgFtzpTeFURNrErI8HXVHt2w=;
	b=Dt69vs4nadlEgOvJuycxz7hhfYgnkZI4BBBqCXpTsbaiNLFfNN02DsZs5OG1G2tp4qJ5mn
	LT5VUg9M6haNJ6r86Fjb38IhDm1NK/u7GvwsLTrsRofXNVi6XPFoC9xks4qejdkArvH2OY
	Vs35BlG4AvhHu0cM3nq9VyQw1YdOd2c=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ac/A8LEd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TeY0eEJb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761916121; a=rsa-sha256;
	cv=pass;
	b=OVqQwG4uGWzsEenZ/dMHESvfwfW3jVkkFTVK9mS4Ex5WQN/8L7eBxuEC+wmmOLnsRKVtDS
	5zd+pfaibDLLgHmtckj0wnmrCKNxGlvdg+oTk5cbXr7zm59LCmRhAdveYDIEhMnDqqooM7
	KI77MGZ3s3ITnlokHs4hQNyNw8Jd7oU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59VCt6vT025937;
	Fri, 31 Oct 2025 13:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=by0mBeTQEMFBznlAGo
	wLgFtzpTeFURNrErI8HXVHt2w=; b=Ac/A8LEdV0q/v1BnNUHwc1BScDJDIYqzzm
	4HhQ1TMyh0/H3dDiF2RXdamISvpXWd6X3oC/ofPIQLAyJguEPWJaObefczru4fce
	XWeW6oP0NRb+7Icg3C9QPKnN2iWsf6zvormF2QMd0XWKgUX05XSq5Oat4pXrNoiV
	Xz9pQCSW8T0AKX0bS4KfwXA+t84OULmAmWxbZVh2uVK63LqMThDJ8a2QNdZLrBpB
	E8IUnyyUxC7SajnMR3/7HhNXlwvKEBWL/v1Q3uEIU7tosG1mYTN2r7BSmle6jN/m
	pWSvnIetopcbSgj78K4BmvDhGUyPeDpjLV1kwjgkUZRfkVagxSBA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4whd81f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 13:08:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59VCMljT034106;
	Fri, 31 Oct 2025 13:08:34 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34eeqrkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Oct 2025 13:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X42gAjzBufQTDyrZ2/iWkJ/U59VIbZ1AW81Z3LB5p+VaS/+w2cf/7hnRBLwxvm2fSzmICxvTWaf6K9/MxIoswxZWg/ACwGDKieBCpMFHFd4bFqtJ/PlWR2hA3S6F7sklIxImiqVrfyJUTJXjAtLR3cBCfDO8nvfYlvimjVEG9Fj6UVvDnU/axelQY9ZUZM2BXGX0AU+EtFXQOZVvyTVE8jNWGq3bS5XJFxLwR3qxQv+i80iXxZnsFHvVKY6nIk0TTXsjxWkXD7xzkMfzuLDLTysUO9gT/zk8jl4Vl2MHhG6ooUAv1bCGGTBDqe8/hKw4nWSBxykORamPCyUytSeAPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by0mBeTQEMFBznlAGowLgFtzpTeFURNrErI8HXVHt2w=;
 b=XogrkNw5E86Qdq+kILUR5NHzwB+8ixO9Q1s3tnddbc5vXcc+2JP1DXXoup7jpSSk7EO0+O76YhhCNmKgeOH9JAbppro5KTTJSS5UneYi/gihw9GprVAQq259bkc1bu0y+LykH9YJ4pfu2RWf9zp1XNRE31IiFQN0EurS66BXVAGw197FvSciAzApldCvQEWK8GzuKcQmzcDAOr56OOfClz00qhDapfQIyy+JQ2XSRfA2Y3us8Ge6xRfyUMoDZ+ymT6xI0byAbZf7CK8wG0o+nl05I+y8Edzj1aw3YfJN9/TdMq7+OXfF35PHXGfThFjK+Nxirz7Xpeqwdm4N5Dlvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by0mBeTQEMFBznlAGowLgFtzpTeFURNrErI8HXVHt2w=;
 b=TeY0eEJbwC3zasvRyUQEOW+m7j/jP/QxEfyulbnrw057O7F/397LByOXtsiXdX0vnjgvBcr52uP8zPxDkm/Lt3kPFkN2y8caTHKov28J/cDzz+t+znVQPxB+HE3NtCOVdSlg9eYkqDT2/d/fkWbkXpFdDGAWUjiIPD7jWTokEhE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM6PR10MB4172.namprd10.prod.outlook.com (2603:10b6:5:220::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 13:08:32 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 13:08:32 +0000
Date: Fri, 31 Oct 2025 09:08:28 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Martin Kaiser <martin@kaiser.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: fix tracepoint string pointers
Message-ID: <kfzgcg2ir4v3evxnlfui7jrip3zozsmpxj6mdisshw5won6qvs@n63xfjfnlxkn>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Martin Kaiser <martin@kaiser.cx>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251030155537.87972-1-martin@kaiser.cx>
 <20251030193206.22bb773e697b6cc385d5aa67@linux-foundation.org>
 <aQSOAkBbFkBfYxPs@akranes.kaiser.cx>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQSOAkBbFkBfYxPs@akranes.kaiser.cx>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:303:6a::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM6PR10MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 7169b611-4f9b-4d49-3f5b-08de187e9763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dyUWB6Cf4FQtnRBywnojeIqQLaWgKDVTpJlfu3YcAxkz4q2QEWy8kz33OjoZ?=
 =?us-ascii?Q?pxvrK+0QN164Zrlf0C1njdSn3Y0AWCQil22eEBuUNKxVjwdBIYW8WlALHH09?=
 =?us-ascii?Q?WurKoyduki9OvOKHrvlXztvj3pj4QnhaJ0RBqKX+AtZxuaXiGxK+76BYiuvi?=
 =?us-ascii?Q?ngp8831PRdc5lQbOGEGN2JRRBMhmqdL5oGrlKTuEudke/ycOYXnUuUv6O63n?=
 =?us-ascii?Q?uYOX8SL9qlHnewfvFM3PjPjagumAFFTI4zE7+VO09dZzLmxU3rvGa7szqC9H?=
 =?us-ascii?Q?QGkbhAJtJYpEY96BeJlI2JvwtGVl8iB40t3iqfohhxCqhIy+tkBjxGoDJKh6?=
 =?us-ascii?Q?ya5ahHP0lf5rsuCRvx0ELvFtlLJTwUcx+CWE1IwhUKrE7Qd7DyED9qCUPetQ?=
 =?us-ascii?Q?nH6DZruDaV+H0VmyOtBbevRv+Lk+/t3kKCG2fX8ROqMmpCjwEt1d3x5uTXFK?=
 =?us-ascii?Q?lqKFo1r2vaYMmoq6ijEsQ2j2kLkm0j7vFt+wIFeOgvRL1vMzvo1LWZ3ONyx4?=
 =?us-ascii?Q?Z8IVTI8IX3My4334iFgcRLe5EkVSA8U6UX78tTgyP33h040s3ZZ2i0tDRkQU?=
 =?us-ascii?Q?d5rJQAK7rTPRcjI77UWTnB+CnesNGU973oVlLkniRAgcnR6ZYy3ZT8PiKbzV?=
 =?us-ascii?Q?hl/jnpxsXe6c47i2mSWcN6/bJy1DzB5UyTMxZZmLEHH2KpXItdx8YkoZXFos?=
 =?us-ascii?Q?dEAfZSsNg7obI/JQ73NmL3dma7e2pmNIbmEGu3Gyr8mzrrNaf63RK8/bpnpZ?=
 =?us-ascii?Q?ovzDCukRCPGGQR6vjVyjIaTItCP6NOj/ubWJgGr1kRIGUUsreF0VIvKgvNhh?=
 =?us-ascii?Q?PqMnqUHwWZ57qoeufLUetUeg5zoteKEBT0kBXs/U6yzIFJKzXMz1VssE0tih?=
 =?us-ascii?Q?SnuY+vvlOA6EkjYmflfkyWHSMI9WxnMugpZ5ZvLO+73KiYYHMP/bdv9+NFLD?=
 =?us-ascii?Q?yyX8gP4uXgjpzd2xXeqT737dN7AY5H0v8vQu9BnaQ5UlVp0TIk8MNBqUGWRv?=
 =?us-ascii?Q?/jGH0wrJT2r4iRQNvHJHe4UKnMLGntSGNVORXQKTRPi9zoSKCPorOVDR8crS?=
 =?us-ascii?Q?IYtu09FxThrN/CVuzhuCjN0FTAX8pV/i/2gUVkpR5Jq1iRN8bQOVL9lzmcFl?=
 =?us-ascii?Q?xKIbG+0XEkioKP0Phd4NK+931OX2fSg5Xiu+9XXbPs1+zzxHZVNv82+Ot2M0?=
 =?us-ascii?Q?Gt4HkvzrS9SEMAVDiMj39kq7DKA7LFd+pOV/XaaGrAZAcJX5q+GDiaGDmGSD?=
 =?us-ascii?Q?IjPs9EIMDIXCNsmTYHWyHIoqjnl3obIZ0OqKcv5laPfTpvcRJp9dElg5v7xZ?=
 =?us-ascii?Q?ACCzZ0UpKD5KQxQUMVRCskO652GZTlnhabrRNCvktB9O/uqnW00hRDmBfFR4?=
 =?us-ascii?Q?UNVxyMtsjZLff3epglq2Iy6tsYvPiHDmIuZaOsNwRRaJEKTOqHSpR9D7rqxm?=
 =?us-ascii?Q?VOJYEj04UeEeL8crHznrhlyipMuY1Zkv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4G23CEHF6IoOaCwdXrBVG3oGir1MDRHD5/4ErezBJE/4vPYMtMrb623kzt7R?=
 =?us-ascii?Q?f69OS8VKWUwoQv4hu/XY5k+wli/0brf50vjigVsk426eyqb6IfSpJdiMNivp?=
 =?us-ascii?Q?mbw5ME7M3qiL43GECtoPkGveOx4CbIFOALbVqy1Q4iyzBSKbXfdPG6fcqA9+?=
 =?us-ascii?Q?ZGT2dzhc8hjgh9WsE9vDKMJEczOIqGD1jminygaqOP9QdE67rmkSIZsBt97S?=
 =?us-ascii?Q?+f6p1oTaXQ8mXj9Xjm4zjlv/Wc7sA6hKRHEufkow2Nd8TZczhwpLmt7A89Zb?=
 =?us-ascii?Q?qKf8bVDNBEtO02u1ZZgFrA+Eq5ThfPowNsUTqkgjdLIhX91D+GM3EgyXulul?=
 =?us-ascii?Q?JBsDsPWcSzCtQTD3ELJBT+zmatc4OPJ5Qp+UWrgdLu2Ncu38dm3NVugnXQTz?=
 =?us-ascii?Q?n6sKWSZm1WpM86BBudX1yxIE9S0n3pySA9l6IDu8jlkd0cQPH7zK5CbKQr25?=
 =?us-ascii?Q?Up722PcTYOMV5T9WRUoB3OmWg58cn/MzZf6i9vMsjbyr3NNIq6Lvp6DdL0Cf?=
 =?us-ascii?Q?T80t71X1QD+ltEi2AA+OOHRq0TeDIhlKCOZgcDVT2EGLgMkRCGqnBop1Y32K?=
 =?us-ascii?Q?wtj8dbf6ORcZGiCirQqi+GDTeSaPwUO2CHksbDQ038zJgoeT/S99nDQ7OQZA?=
 =?us-ascii?Q?U8tcueiHKpI7jZOdp11WkkrVDdRlrV31rAs+wWvLnkilSsQR0Cff0bumpBUE?=
 =?us-ascii?Q?vCaPj/z7uHXkuHaBjxpuHy9/wSN561is7AbglimotwlMSNOTecTgNL+svycN?=
 =?us-ascii?Q?xnMFxVof5xvUnYWQTh4niebAnvtdgGkVZMT/3s2BWL/WlyIIAZviXYM1OAph?=
 =?us-ascii?Q?ESbAMiv4IID09h//LOZGUeidOL2pjMcYlXQxiBQu9bnI/KZ4BZXZtbHUapNa?=
 =?us-ascii?Q?jwny6q5wZb9A9FYFzIhkRqPiBIH8j2DF8Cy4rNO8D4ETj/pCJ2QSFDGwLUdE?=
 =?us-ascii?Q?Lo/yU2f0Uv16n4JyEPp8UbJRmBUg81RNGL9dgeE2Gv0OQX/n17L0fmQz6dN+?=
 =?us-ascii?Q?LFmb5XTsz/04vGNs921VWToRcWKPhyXpEpGbTdqoMdQRFD+rAXQBup4S+JK5?=
 =?us-ascii?Q?e/oIR/qWmcjrSZEi+zzUqOExYwj5HSl1ATxNcJ3Sbdipqb1XfClT3IAi3KXY?=
 =?us-ascii?Q?+tul2v80UJ7tHPrAjnj19LX0hy03Q2M51AyJ/RnuhuGqjaXa432y9bbbMRiv?=
 =?us-ascii?Q?bY1n3PmnW1SjGeTVaNItQqLcmOVD0ymjfGcKJ3D6ColNrFLbC/8RFb1nce2O?=
 =?us-ascii?Q?GabBdAWxIxGtSl3YVopG7S8yAGatLIb9eL8tSUAuPs5fTl1OVG0ckE+rEk+K?=
 =?us-ascii?Q?78v+M8vZoVRvDUYz7pzhdWHZf8IufzTXEQQvRojQcXO69BM42Q0WkVxXXW0G?=
 =?us-ascii?Q?6RNJzBs6pQirqjq1out3fgQ/CPBtUCWMkdmPHfu76y4L4KqVoTE8ynmKXlIK?=
 =?us-ascii?Q?+1n4lxkDuOEvo3jP8h9yZqTPwz1P/0jLYr2vnD/ZOM1tPzQ+aG6z3CMR07kM?=
 =?us-ascii?Q?dZ+uWC5UcbSvvspdSj7bVspSdyGP+KPS3WpwGXKtNdwtOiplr5Wtgb1DvdNF?=
 =?us-ascii?Q?hDpxvhNVKwe5vaYnozav4uwyFHtDHk2PymgO+fww?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u3zBU61CgutVHby9NOinvrOlQEj1i0k9Vfjmovqu+nsHas/BwvCgLqLkPlkkqk/sGiSRgJc5QXUgt2TZhqz0yOaU59ysTy7R8l6La2AtOqTyF/fMN8rsmfv+3MBW8FlvZ1tLsF2wyLzwHGDRY4mZ8RObZOwdydwsEwykO7cmwFitnXKpb2LgXAOhq/r5qAXPdqHXukesQIamA951X1Rhp7MxykVF0EAewYkZbFaG0FQNGUDGToHTrhHlEV1mhEbkUlCIkA70a282NzIcrGiS8QD8pjPPJHjMxwr0kSdogaiobXRqQ8oaDLgXklvMBX39fpmwy6yg84S8AAj0qixADREvpvRQ/nvLGy4frrWU4OGA2w0eBlyXbjcGdsl/S4F4dNf47pm8lK/wDbLdAh2V20U41eHHgm0yFKYdAtmUDLXSnmofnPha0yuaQ5ZWmkJdqyNY3fw5PRr6O5Wi5e3JEgROlVhV56y7pfgQNv2o09e9AA7pakduxlmf8oT/xKihTh8Mfa8A7mjq4oTKVfG7p9ng0qcLfA7rpBD4E+1nC5ymZWI6kXz8Ds8/DiRCHUspa+bOzDTJZjCTGuutiCJLdQ5nw/L4JQweJnPNbSsa0Fc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7169b611-4f9b-4d49-3f5b-08de187e9763
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 13:08:31.9648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15/dbJ4xzYXtJ7dwG3JWCxj6B2qGNHYAzyjqRWI4nxmOc0SadoJeE7VaXrl0HtI+LH0TpfE4ANs0XFGSvLHwwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_04,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510310118
X-Proofpoint-GUID: EPr00JeldPu1pknDUjvTf5MJUGUyE0qS
X-Proofpoint-ORIG-GUID: EPr00JeldPu1pknDUjvTf5MJUGUyE0qS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDExNSBTYWx0ZWRfXxpm+kxhrNRsu
 rQ4LQblPKkHTJ/6IJbaeM75QrgkuDM10vyzaBjSycIvi1H+G9PoJB6BSNZoP1N8CVMpASu3VEtF
 GRVzVst/C/uU28ieITv43nvRV0lREVcRUAuDnheQtvtPLH2IdcmvL6zSWG12+o4PzbLvchyiko3
 YxW/LzjcXkm0+9HnpxUrTouigZO2m5NS7dje9d2qedQT0uGcEySZfZFagg+wqoBNfNYaAo3ROwp
 1r5duc7Em5Yy26dpE9Kq7y4yEl8Ps3lDfefUSKDdAbTISbJOXx+mrIVddzOSEwFYGUJWTCti5mx
 p+SOI8YQIOwZKIBuMzP8ac8gl56OP+YO/qxtGLg0mFPy3rUfLSC/sXoa+nsEx13Zzi+/EbsnElA
 V63kZYA3SPmq5bTq9LnslJA/4vXAcgsAqiA8jZaoJK6TztHk7CE=
X-Authority-Analysis: v=2.4 cv=IKQPywvG c=1 sm=1 tr=0 ts=6904b4d3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=0Jjn7zBk7p_1trrXy-oA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=lIVgwssKXH9ZBiOKYs9O:22 cc=ntf awl=host:13657
X-Rspam-User: 
X-Rspamd-Queue-Id: E70858000C
X-Rspamd-Server: rspam03
X-Stat-Signature: b37pwqgmcehwrdwjtre8ygzzuqhy4awq
X-HE-Tag: 1761916120-976907
X-HE-Meta: U2FsdGVkX19PU0Vw1oAaGv1qQi6srBg/UyesiFSeHOdwq1FOaG7pM9Fr/8Ic2eYv+Uc80J591ehN/pfmdFgUjLJIPHY4fuxB1EJTkB9Un/ky/2qzBmZjcEsqPbwFRnCTLqMrWWfgqLt/jMm//2tTWZEs8sD8j3Ci7HfKasEbhKJD97q9YI5FqnamDXmtbHKEPbqvk04OWKOSt+EeXZvZg1kne17RzH5UQoZTeNtbYk5DmfKmcHQ5HUo4ggSG2YK1gQgj9A6OJd3V61gt8NoHZv7YaFWEIjMvF8+6CpGuFPa4MiSN+j+sDo/z0xdfeL0dRqBGiA/eHkkeJhExqRAlGhO4DoAJREVouz+BIhkNe/n3FLtmWTfagRHc/+h2DutvopqN8aI9RXJgt9K6PlYjJg7F9rp8NQze1FOBbob12/zIUPXeGQS+I9APVDSew3xChCjS+//5eTi5Tan8or/hrQ3VqLVkRq95YzxxJ225oWRSS72WScWSAs/kE1qaq2i6AjqXiV+S22UtXrnZMsKK3EI3kEzePhd6oWDhuMkfNxxs1kkPcm4n8SZp55XXOR8U5Xb84DORO05zesvu6S5+0JGuXVj0xPDPBsbM+l/UKSpagveMAU5KbB2zo+pvkrLI1cD1Kr21t2/KSTxYyQUGgRWQnhNayDdPPdkGDqnV1wRkvEAzovYBMBDxucrAMKRq6ncZQparix4tP7Sc66JhrBS3hWKWDtE7twkJyxeFcjcdsq5CNtZF2qDmQ2ycxSg5Jc0bZodCh1oi9nzCQ0aMauGVWz7iQDmHd46hUEajp/7yhYdypidlyAmqZxxJLBLDj4EaGI6j2wHz//KC/4nnCVNzRe0baP3gjg8LJZblvpO2mC9464Yp3LAvtUhKKO0tnepU1DEtOvHoInRDz7pWYwQCscOFHMm2u4m8pwu1ZolzpwxSHBPh5EoNNnUyMWgzebXp6tzdBd1zm3Uv5NU
 Y7fWEFw2
 BbaTraLh0k4o6857A3DMDgmGBYZZ2ThE5i34xt2hbqDX9IdrfedaR9/Lm4hO5O7aPf1AnEwRFO+5evZh4bIJ+macpEFIneXMPUUyMcuuQ9AF8Kp9diWJVND4fBK5dlcxTugqKlm64OkVV0eNL8sNDn13NLYEjRiq9VtNqX4S8ZTj4Rh+6RDFa6RcxLG9TZ8FCXXEMBFBtAn5f9/T5wjNbcg8VfOxD5PDWEuDYmzTnOibiKV4nvOXSPswCkQxqi3UNvk23hr/g6f53CNVuYCh+lv9WRn3IL2+T7IIqwIwZapnbVbjpXSnDXQ54Il0dOqwITCDALGczjqnQ6gNspiSltzf3p7gdTXhyvwZG+yauptw+ax/Iq/Q2qeJtMNlv50IJgORNIaF5vjsHPIgcSYYPK/OTCDj49AQCAbZW96niPH4Hp5X7VJJ8HEsC/IvVxWjI/zZZUT1MYhYF6JlzEB7aUnyX3h2Kq9GEIuTb7ZLkwg0z46tIYX2UA4Ys//Z1UE8PIvZ3v0t59rmkUSNXzEsB2jyKy+aDg/TGFNYMDrDJnyhmArdzEO98h9aOt4SEI4TaEd61/E8VNJVlY2C3wesuL3NkBc9QyXeyfRTETiTlDrXbHrm2RRle37TQ0yj5kdyXqpjrchvPuqAXU23Bybzibs5hYrqn6xOaJuLqXqjEgcBNJFDfNhAXmPC+hmzuRpWyeDODULXPnZ1I+xL0U/H/uGw5G6dUtXKC2UImMpT2Kdep9oUtYfHRUcevfvRqjuW1YQyanCZmB+q+KLz7WOSd1iyxymp4/lUABKda
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Martin Kaiser <martin@kaiser.cx> [251031 06:23]:
> Thus wrote Andrew Morton (akpm@linux-foundation.org):
> 
> > > -	trace_ma_op(__func__, mas);
> > > +	trace_ma_op(TP_FCT, mas);
> 
> 
> > What could cause the storage for __func__ to disappear as you suggest?
> 
> I see your point. For __func__, the compiler generates a local symbol in
> .rodata that should always be accessible by its address.
> 
> One case that doesn't work without my patch would be trace-cmd record to save
> the binary ringbuffer and trace-cmd report to parse it in userspace. The
> address of __func__ can't be dereferenced from userspace but tracepoint_string
> will add an entry to /sys/kernel/tracing/printk_formats
> 


Thanks.

Is there some way to detect such things at compile?

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>




