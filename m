Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093D3CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C4C8E013E; Wed, 27 Aug 2025 07:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524EF8E0105; Wed, 27 Aug 2025 07:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB518E013E; Wed, 27 Aug 2025 07:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9BD8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:38:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBF4259B31
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:04 +0000 (UTC)
X-FDA: 83822338488.22.28ABD00
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5042B20007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ChPj0Wyd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="J/F73ySR";
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgLEvLeBtpAqGZZvbazmsut7zkvMrC39BWs+UZqIa+k=;
	b=WyAoIk0z/DBk+SloNC1SRz7RHzR86V20pnRpgTSJWGLjZPDe7Skr+tFg21RyEid4Pm75UJ
	MhWlkx3bbTPSW7XA89xjJn4iIDWl5yLdibpGn7PPdPQQqca7AQkRP0iXSoKM2PpqgNYCgZ
	ScgM6pizWR5YIVM1pOeRigbbdJaVbgE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ChPj0Wyd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="J/F73ySR";
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294681; a=rsa-sha256;
	cv=pass;
	b=XyCbWTzNrgwolZzuqG/AorBG31wyU9803dbSggaCM0YmB0ZZonjjK1IfJp00gyU4tuorX6
	clhVUxzgAVySfA+ogOVNE3404D0XfxpY9x2ARjdUzu7OdT5D7XTyD6bO1srqCVLdz0MIXE
	fUK3mF70Edv3HAxMAjQN1oAxynqHGK8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7u1hh015858;
	Wed, 27 Aug 2025 11:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LgLEvLeBtpAqGZZvbazmsut7zkvMrC39BWs+UZqIa+k=; b=
	ChPj0WydT0nvpoJDVSjx11tqftr48yPjrYUvjgp0Ny69WLUfLchY3Kda3PCce56c
	s5Iul8mUCp0NMgGo5LmyGA8CjRh1EhCt936xZzJwKHUYwhMMtaBNBB7seHl72BPK
	hdrqb9RY1HsARr1EQdmPIr2gSY8aD9m9CBC4mUWr6uJ7tiOp5IWA1PIuDMIGHudl
	k4WW/siFD8iSoD40o2b0wsMu/hK8SuFbCpfy8x1/Z0LBguy69NDs62Px/6Bn+9HQ
	oSBYFvjJl50sYKdWBgWv+YCj2rPCZgh6v1cwS1Qefnc8O9AOH1IbJ2xNnjkZFCBW
	WFSRjKJNb9MHgJp5XUz9jg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jap93q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:37:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RAUWD4005292;
	Wed, 27 Aug 2025 11:37:49 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8au1xk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:37:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ey4q7IgWzws1V5VQB1Hx8yzWJSCL1uJ0Ni07fzW8p9QEFDMqBl1IiJw9IMDVNwFPTOFUPMLyIHV1NLI2eT4LmwkWyIqnk1OLvI2hXRj7tdvntSAgT8pfL017wREKBQ8cHoa+ZYt/IGC2+ybt3nQBhYa4J1cmHb1x5zN54quMHzeOmFAf+q23yOwN4lLDWJj6GzAvcJRkOhV5YyLymaveDC8Z4kqqGoujiYpjmKtaDWv9UenP7SdXh5B7AVf/CqZVmxlpa89yChVc/f1Pvwy2BOyXIKOR8CmP4pXdxoGWjiax78FUyFvXVtbO2bq7BXEX5NKBWBF/U8T72h51b5Hh7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgLEvLeBtpAqGZZvbazmsut7zkvMrC39BWs+UZqIa+k=;
 b=tYA0lSZFe+PwEbfQ/qNrHJcBmK6PToBeo3PAOm69pL1FjlwEMmK9Wpto/3D4bvPA2Q3sYj7caJI9YpcD1Sngwz2TgS0Ef0jylpck2pxM8M8I8xy3/AZBLPhbBOi3gtLOlfNC/gWqMNpn2tP5tusErsgSy3PD23IuYFsQRQXdnXMHza499uUp9OX0ETJ0hw1pLKXBUdrovR515Z0lcMmx6uIEnrCb+qDrUcqnCPc3szsUemvVvkG8JpPthUtGHr6CkehCX/nglEz5dADk2NNwIuhzqgYLIRoKfaY4QH+mQwPASLx+HyYz0MrqB2sEnANot+hduQ5UN3VlAfeJT0couQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgLEvLeBtpAqGZZvbazmsut7zkvMrC39BWs+UZqIa+k=;
 b=J/F73ySR3QlvAptXQmjrl8OUcHegt54g4+1W0HYrOD5S8sFoDJRl/IRm3tMQQJd4YtLHkvWifZ+Mn0HUSjgbEOVyqOpNJL9hp468io6uHbv3fImYiijwTHZSksk7jBpnvQ4+75E0gx5zg38nopiTb4T7p5OHXGTfIft+qEKuSkc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB6721.namprd10.prod.outlook.com (2603:10b6:208:441::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 11:37:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:37:45 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com
Subject: [RFC V2 PATCH 1/5] mm/slab: ensure all metadata in slab object is word-aligned
Date: Wed, 27 Aug 2025 20:37:14 +0900
Message-ID: <20250827113726.707801-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827113726.707801-1-harry.yoo@oracle.com>
References: <20250827113726.707801-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0196.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: ceea4464-c606-4250-4035-08dde55e23a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xzKjesyM4X42h7VD3i4dysUzSiKAIY3BDUjPCFfNJgxrYtyrLcK9LbtGONI0?=
 =?us-ascii?Q?LsYnxLrdYgU9g1azE0ryTlQVis8WQj2lxf2z3w23/phK0+EELW3oYYUQDlng?=
 =?us-ascii?Q?AyjXhNYieDpUd6YfJcaOEJfENxOZdIZYni9jugTjxIGC7ta5IGtCyJ4Vr9p1?=
 =?us-ascii?Q?n0o1J0nPXPTrBv4ygRKbZcndCfve/FVHyvmY0Sd4XP/XI81zR0SeRP0ifO2C?=
 =?us-ascii?Q?M5lqblc/3bt3d529pg7h83E7n01tEF/N0YzsZh82Q0z9md7ea3ciGeZnWSTw?=
 =?us-ascii?Q?awchl3rdVIL5e3QA0m+xx6Ij600ax8zVxKi0rgE55RBmJ0iBcFdZDsqePZ/n?=
 =?us-ascii?Q?XNCsKy94X1KFB5Gp4Tj8QGxVi+9a2aM/agVi+4Y2FJNXRn3J3ksG6c/HapuX?=
 =?us-ascii?Q?dUi7pAQvv6RklSJt8ry9T/YvS1IBrWw92BeZjrqYmcVrKMOzfmcvZ3UceUw1?=
 =?us-ascii?Q?p7TfIROGE08TPod/CEtgSutBHSE8We4y0uyBOfOeBMCZyFbkVzOq5+qHwaQS?=
 =?us-ascii?Q?qGG/LfOOblX/4yahy5C8JtFxiJ3b2twy/zxqUxRlmgWkICVp9AYYtUAYMpCo?=
 =?us-ascii?Q?ZvkUz11YvxtyY4XRkSiZH/6278sKSXpJ/APKjNZm54v7bQbgP5u3qlwNLVMt?=
 =?us-ascii?Q?TveslQjh0Gr8XrE17krklehy8Fic3oZFVsGhNk15QvEAeyENU5WqkZeCVJx/?=
 =?us-ascii?Q?FM/AjncFmLrW1ZrDjy5FNrTEFyyK2UiNO3kt2UzAvGMsSixIO1g2kHaCaXMF?=
 =?us-ascii?Q?4s8GIUCgQoMbVTP2mJgWvHGJfShrjd70Kriotg2gxwMF36jfqsHLtS0JbAY1?=
 =?us-ascii?Q?E+oCeXTHgil+2KE3/4P9teSGAgoukTvbKGD9mzey7466Us6oWOdvJonIIbD8?=
 =?us-ascii?Q?DUN4ZoFc//5M+z9mZI+iL+oEWN+g+yEzVKgmCuvjKkKPJMmY139N7jW782zh?=
 =?us-ascii?Q?+LxhYpBeo1mP/AjrHLdmQKVrsTlbjfxcumUJlFsx5Gh6h8rg8JSYQQ6+l+wn?=
 =?us-ascii?Q?Yb2wi1rcdvdpNSAU9BJh9Z89J6dhQ19KqwG3rFwE1mogiiSabFE+nACO2YIA?=
 =?us-ascii?Q?lfGOfdQADEQDSJteGq/tEQf+Yo8vG++Hm39M7gJ0ARXAkWuss8IKtXdbkeCC?=
 =?us-ascii?Q?RZLKWBtj+tOblWbYl9CJb6A4IVqtq8yutXn3u2wSYyXhu+zLbYsjaXgJ9xUf?=
 =?us-ascii?Q?BjZgzyuudUYnWnB48ZqZfln4p31LrU2aQhaCK2FZqn3u4wMuZsWU6AwTo40W?=
 =?us-ascii?Q?4jRt704wpiKgxbDlYND7RVr/EXU+4YZfNopbudDt4SOr+efYCCOas6hEN4Qy?=
 =?us-ascii?Q?p2F1Fw74VZTR0JqP/cB5zHYnQTYvlyG1xW1q2fE0GQfZykMJOUCf4jvZOnay?=
 =?us-ascii?Q?lY3dzJfeSqFcbwLmAyMF8fvUQWNv4X5wWNoA6f7zLHqghOj4idGHbgt6ln/a?=
 =?us-ascii?Q?LaeYO8Zrgg8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hrn3rSSFMe6Z4Zc5MxcasJwE3BqjwCVAqIwrn3KJQdZqq4voZiWj11jYROAm?=
 =?us-ascii?Q?pdiNN0m3xWrW2l9fZYa1DURkzUoNXroR8U2Aidf7doffib3455/5e8mqy0Lk?=
 =?us-ascii?Q?ou90ZQUyYnT95aWDQyMgpvMdSg7IPN/r+oUOL7eucTpbNd7FKJmi6fp6PzfD?=
 =?us-ascii?Q?kWtWO7v/tAoW3w7PL5vn73ahOSByxN94d3ODVHLZTWsUQpxpsWkj67+57nfn?=
 =?us-ascii?Q?cu2XvK0HACcT1dMXyEbyZn7OhEtGmZ8325Hx4tjy4vZ7IFWOORlIYjVE+A+Y?=
 =?us-ascii?Q?ioL2iIsP5bgzmANKBCWzbY3FPPllxQwyiGEyz2zZgzeNOPbrNGfHRMEdPnW3?=
 =?us-ascii?Q?/7ShWkityfwXWbuPiFRTVdnF5u9U8wNKseZP80QxEcdI6gEvQWiAx3MAzYGZ?=
 =?us-ascii?Q?1aEBkL+M7hl0DvE7Exvs5oMYxVgjJeOu2XoxRPVf9P1sVCQGuBY0uUtmmnTl?=
 =?us-ascii?Q?IuCpqV8aZvjiu7OSZKrY2XTpUuuS3/HR2tL0Q9Ir7Axtr0FS0Ak1vFiMOPau?=
 =?us-ascii?Q?Vq0cLFav/ffisILMgRu4GlQisGn8iCA+WSUmoy0Yrj/juaLYaROkXinT4mmU?=
 =?us-ascii?Q?eTWOXq5hm4GNK8X4GCbpVNnT7EkXNr4AmZQkqxLAeRsVJxnelY2YZxIcgxtJ?=
 =?us-ascii?Q?N26b/4Ke8QcYi3cfvPgl0uA9C+mxoXi8GwjJwN3zMn/Q02l7tkyFiE/B71sJ?=
 =?us-ascii?Q?iSnV29vBBq2ARUjReT+vpiZW6SRO6BgBZ5+eppCHWwEzWgQrpBrf3WJYvgof?=
 =?us-ascii?Q?KpNg8TyziUTgoHOs03NNBebuw+n+JLQyLVyt0pNmvUeRCUBvd2DvThYNgJjw?=
 =?us-ascii?Q?f5f8mLf8LQXjveSyPKtJVebtJu7+25jy09Kqd2RX5loQlBni9FxJcivjNY30?=
 =?us-ascii?Q?ZHzn8202PCmdu/Jgv19oIXK+T7M/mfmWVXO42UmmfA+cuBl3Ie5uwWmwXZZD?=
 =?us-ascii?Q?ZuLGPyjYkhYly/D4aPxvlvH7qwKrPJtZuFql39OJWFE0J6fR4VqoMTmozz6i?=
 =?us-ascii?Q?wzIDAGdIbO5C9Jc+7KumzkFLvJvkZ791HKBkjXu0DjgEO2nJyHpLIDtUqDK2?=
 =?us-ascii?Q?OvQ4ymGTqv/NHwEVBmgB8yuPpydJcC23BwmdPnPrUuZqWef7hJNjkLdZnsXR?=
 =?us-ascii?Q?20cWyL2pGcBrzebhgeWMnXD1wmTerqlVaJPLoY+PK7xw+CYGgWhXPrapBZuA?=
 =?us-ascii?Q?of38QjYpcLhZ8o8IKz0cP/ehuJGgVY0UvgyR/Y4QvxkwHtL7DVqZe2u+Fr8Y?=
 =?us-ascii?Q?sT9A7Cv0l1m7s75RPhiA1eq8rfusXAjLHKxQ7Pnl7M9MeuCJVkGxdGTVUYm3?=
 =?us-ascii?Q?KexfdvEKVtVDHTWnmAnEAWiHklN4qL5lhx9N4obqBUzEdJkPu8RPCSH/64nA?=
 =?us-ascii?Q?9YXDOiQGYpK9BLi66/qiub3xOG448I6DhvTV1zfo6S6IPMSwNvTjBlBxtcX6?=
 =?us-ascii?Q?3zrbSBj5vfaDi412zATNvzCJ+IjZLkrCQKOmWCop5krQ3ceMa3g6eEwHAKeG?=
 =?us-ascii?Q?wTMmzHsG0u513jtXbNHlPBIkMG5mI/WikuJKJPgKRUJWd6Ly7aamWRe2z/PW?=
 =?us-ascii?Q?/Q7uYaxA4iSV7t2pQTj34abMFVKTRRvUX/drjLoh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c9P+ArVT5G8F7KbwgZabl/9ctss8ifyyGQvvNSgYnd8QQQFzAJ+YVrvD0H9oW6xLXBC4RDvtFNEe7SZQAlcNP/9gfcqktkl8Qp7n4SlC/GKaNdVZBYJ+DxHtVXQTNjmR34UWuMUy9S7TVWwh93VsvL8zc8TS/p8DdIZKV8TbwzxMer7xpu5lZLnvF9KCVDSrxGbwylz55NG4Qikf3qlQZZcuL4UgK44PMRKxT5dgrSwz1KvJoTT/kHbpaXUFEht/xIlV85xNbadFHmm35Eo4J02xAacpImIExtmBC7gPMZ+7crqY3cUbYw28wm6OmdwcEdfq/7e9UX76PyNm3+W4Pe82eLH044YH0vJ5R45VRnJBIJ+NAiSQ9GT4jhS06TYkgF7Uq7w7xCnssBgXwEsskxUb4rJfBzdpDw3MM87469cJRrE069eSwwHwmkMYYpj89lu0zfsG6WpzP4/znsIeuPd5a6DuUlGTgUoDfJzh08mdILWNk7q6cY97iBaphtNhey0ESB9xZ53kWW+K0LF2cH4lG7OnQ0J5l8lJ4D5A2lP+jpPMN//jz1eLuT3DnekwczJXQmyEpb9yWgbykn0Fq6W4wbdDB6wj66mRzvvQhP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceea4464-c606-4250-4035-08dde55e23a6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:37:44.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwjOhzgOKvHS8Mxm+uyfl6E4EiW10oazTAV4kI4hOY1ZE4AiBg8Fr3XAHI6goFszWv8HzLFEaxcvW6Zwm2VZug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXy9vixeTGrINw
 ksfubcxMbghHlQxIweo36JBGVkqAR8awOJCUhBLdkkwd/v/Q5jTO+P43Xlo0nhVbs4yQtg41Afi
 iK/X55mL+pM/2zqgylgQn9+AicwtHOOSCm2INhYg1OUV9p+j5yllS1Oj6xpqL75Rne6aktAGcb+
 eMYi3ww+5A6SK7CrvZGo4hwrJauPY0kp0SMs+L9zpkbkC9XvOvZUfCNCw0U4PEO3dYLcH4M5eZx
 SZrf6tHPEy0HH52b66ouJEZ/gtQcQMLJkiR+EPhocspA297o7X29rzByQFGoNLdbnuRF9tROlQ8
 qqcwIR4HJmAWR0sNyhHBDyKOFTpxOd9ZG9YkIs5LzghZDQNRL0WUUzechhGG4ne3KIB43vW2LJB
 NNk2ohYyVvwQTg3y8D0O+GjJ18FoAw==
X-Proofpoint-GUID: Cyz2KKz07YVzR1J6GLs4q2Ak1RpAHFeG
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68aeee0f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=6HMqm_-An8ypX_Bavp0A:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: Cyz2KKz07YVzR1J6GLs4q2Ak1RpAHFeG
X-Rspamd-Queue-Id: 5042B20007
X-Rspam-User: 
X-Stat-Signature: cknj8oh4uphnky1y61qcsq54zm1d99nh
X-Rspamd-Server: rspam09
X-HE-Tag: 1756294681-817809
X-HE-Meta: U2FsdGVkX19D/pe2Juyfx4zaFrH6+Cdzyu/AhGLe6ZgrdhpRqSKIBtxxaE9pkOC0qxJSG0fe65WitDUXEKMPzbo1tjuxYA6luJmVGMrDMDmWDfqa5cQPXQs0LukpSBedsa1ZQU6W3AnXy0Iq9rAHM9Dwxby8VDEBCwVnt6f46Yx4PGa0h+31E/DqCPbDkCULPmfjOpZf9uhn+gWaHdBrt98EK4HsbQEucXWRzzZfp9hzSw+5L4OINsQY2jUpGHLGK6pf7vNYrUHBxTLh0JQq/mJv6EEoYdlkZQJl8XfsczESE79jiyXEiQkNlPJsbevA8ls6Mv/f+73QdlKAF1jl+30eVFSDQ1WuDBRK32ezyCIbjWbPWaF05JshLTM87pfkRiczt3rf9fggC8JQzT9bAeHtcaWTiAhIU/tilNrzXdOEiuMu5N2REMwqF1P3tEXmWlSSPwXbbhzqr/2NkUvANbNJ1D5/cgyWdwxV4XeTKpMYovkwdTrZG7rCZIUjWBpIMsMPCYHt46UOMvglH2Vt+BNAjJHIhiiM1jQk8YeBCpUkEZT9hGTVf/rQLCDBJdD/VJ3KSvAjNnBlc4MNYEqsKKxDQ2itOmBXmjxhNLcTHEoowAW7pmS4xKFuFd9oLYPVRv9Qtf9QkL4AmdyqMa83moDLVRvsSW31q40oE1wUFvqMP/PgarS33zBKNLTuSpEE4PnlYLM6Jr7tsrL54A9nACkH2IzXhTdrq+tRcHxNYm1r8SVIg2trUweG3O+8eyYH3syiZei2Z1WIoCltkLjEc5nsi+qYkOeMyiExPW/NPdvks2/+C790wFBiE0ZEQcgX8ejX6OywQssk2iWKnyMFvy9XJni4ZSV4V6rhmwqg/e+v+m1u1Kym3NnwntdnYrsqju8QRbSqLn5oEDEYuRaCfKdZPYlPOyEtPES2b5NdYeeYWwmWPidRZAhoFZe17QUUtMiC+rlFTlQdiUh7sl2
 hzkVxNDy
 Er2WY5RGZGg2/uHsB9uBf0P1mQV0ho9s3QWfo5pIDD9e8ExYWXaM9pVCmfj0fcmCQhenWWy9LDnFWixsS8BQV5TckZNT5QL5NqYI492bkIq3XOE5P12ASm1ZyAdt/LRmthIiYgaRgMtyeLON4qMeUl2dWm8ldJk3BsttLriKDHPjvCeIYJz/Vh3WVvQSerWjUNewoy4qiwmaZQe/pJN4/ZrkEx0p/LxARw4H/tD6vlrEv3qpJLACqEM8yGjl8gOL7zFQ0M3StIDWdxniB7Fz/vpInvfVgZf0fFwxw+NJzb81wao4EBWv1xVmI1nWZgjXSErIGeijIQ61HwU4npEzWdXTaYkY5jJEuZbA6edOPhvPPug5tpFfAEBKh5I0UALhibt0CC2p18+B9Dac31wF1NpnJhJAj3F4VqRrG7neoqJ0GNGHDpaRDSkM4bkDs7wuBFsv/iei99aXVo8fF0KEEnrn8TiP68ja5YPHHvVUVk3MPnGZGfQ9qfJCzujHYBAdEdsDGiQlvZ8LrrrJY0ewUC6nIPJjcOxNf8JqYTdOJyXRxqRi6dnKy8T6aBU2UK/JnkbfDnI0AMohnS0dcifdbpx+NxvY90fCaXHnfhMUgurPzhE+KpZ3W2cQZE2C623OYgAHa7giPwa67txlGDwZJspSxmAV7VjAIqQ+g0XvIGT8HBhM00Dr8vCxufH6nefpXCjE+Tdoov0ceyClioBwbHwRBPGQurchQ++3fDcs1p98sFQMibJDPrrP86DSgn/SD16E5UTkdWhnknZQLFsXA/sDlQ2N9y0NVgFu19ABSfjMy0jtdg4xfTonLjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When SLAB_STORE_USER debug flag is used, any metadata after the original
kmalloc request size (orig_size) is not properly aligned in 64-bit
architectures because its type is unsigned int. When both KASAN and
SLAB_STORE_USER are enabled, kasan_alloc_meta is not properly aligned.

Because not all architectures can handle unaligned memory accesses,
ensure that any metadata (track, orig_size, kasan_{alloc,free}_meta)
in a slab object is word-aligned. struct track, kasan_{alloc,free}_meta
are aligned by adding __aligned(sizeof(unsigned long)).

For orig_size, to avoid confusion that orig_size is an unsigned long,
use ALIGN(sizeof(unsigned int), sizeof(unsigned long)) to indicate that
its size is unsigned int, but it must be aligned to the word boundary.
On 64-bit architectures, this allocates 8 bytes for orig_size, but it's
acceptable since this is for debugging purposes and not for production
use.

Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---

The combination of:
- architectures that cannot handle unaligned memory access
- KASAN
- SLAB_STORE_USER

sounds quite niche, does anyone think it needs to be backported to
-stable?

 mm/kasan/kasan.h |  4 ++--
 mm/slub.c        | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e64..d4ea7ecc20c3 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -265,7 +265,7 @@ struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
 	/* Free track is stored in kasan_free_meta. */
 	depot_stack_handle_t aux_stack[2];
-};
+} __aligned(sizeof(unsigned long));
 
 struct qlist_node {
 	struct qlist_node *next;
@@ -289,7 +289,7 @@ struct qlist_node {
 struct kasan_free_meta {
 	struct qlist_node quarantine_link;
 	struct kasan_track free_track;
-};
+} __aligned(sizeof(unsigned long));
 
 #endif /* CONFIG_KASAN_GENERIC */
 
diff --git a/mm/slub.c b/mm/slub.c
index 0ef2ba459ef9..9e91f2016697 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -343,7 +343,7 @@ struct track {
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
-};
+} __aligned(sizeof(unsigned long));
 
 enum track_item { TRACK_ALLOC, TRACK_FREE };
 
@@ -1180,7 +1180,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 	if (slub_debug_orig_size(s))
-		off += sizeof(unsigned int);
+		off += ALIGN(sizeof(unsigned int), sizeof(unsigned long));
 
 	off += kasan_metadata_size(s, false);
 
@@ -1376,7 +1376,8 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 		if (s->flags & SLAB_KMALLOC)
-			off += sizeof(unsigned int);
+			off += ALIGN(sizeof(unsigned int),
+				     sizeof(unsigned long));
 	}
 
 	off += kasan_metadata_size(s, false);
@@ -7286,9 +7287,14 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		 */
 		size += 2 * sizeof(struct track);
 
-		/* Save the original kmalloc request size */
+		/*
+		 * Save the original kmalloc request size.
+		 * Although the request size is an unsigned int,
+		 * make sure that is aligned to word boundary.
+		 */
 		if (flags & SLAB_KMALLOC)
-			size += sizeof(unsigned int);
+			size += ALIGN(sizeof(unsigned int),
+				      sizeof(unsigned long));
 	}
 #endif
 
-- 
2.43.0


