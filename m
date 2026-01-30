Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB2CE6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FA26B0089; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8EE66B008A; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB926B008C; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7726B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DB84160807
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:28 +0000 (UTC)
X-FDA: 84389848536.23.0622451
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8555C0010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I5Y7UW3X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HKo3ilTA;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/gg4j53iaCKD0KGWq8T3PWEEPapxaZjpkAJqf5ZsUzk=;
	b=nUDH9oVoTW3eeIgSNWQ5+aYuTl+YDC4JDih6tgMQX+ivxcivH49g66YOejgywTEb9CBW4h
	Mw+uR3TNj/YyubzUVtP9uMaEA5lLAi5YEz/n3+XE+z1Jb1NgCFgSvSMHhsZs8m+1VGrFUv
	FbTC8lgKo/OoqgxYY00fbFzNJjlDQSU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I5Y7UW3X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HKo3ilTA;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806825; a=rsa-sha256;
	cv=pass;
	b=B0h85D7yY1x0KqNfsrzlxuhM2xvadib1rWj1e3rlPGDRMj9IqcO/9YH4DZ05H/dymwUCYL
	checc1i7EgxzGb4mgF4AYcL6ePE6gHPQGVcBmqrnNhArZkjE2ychW9tnKeppaw6zCCx2Ew
	5gW2PpzwquSwt1tDfxhGXjQlQ2Jo3dQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDGqP3732443;
	Fri, 30 Jan 2026 21:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=/gg4j53iaCKD0KGW
	q8T3PWEEPapxaZjpkAJqf5ZsUzk=; b=I5Y7UW3XN1EhTf2YpVMa+eulDazYQ16Z
	xLbSdv8aMyoh5PL8MaCqyHTf3V6H+mwAMkHwjhVUUCXaFyPN3URS8r6tGSXQ98bi
	pmqg+UHQt+hg0DBVcXvHeqyND/LJ7RSNrJGLXdxmHR7KG+KIBqWSwAn1i6OUuDRE
	7jwCRDXkq/h6J2H0fr1imk+qOS4vx3bgh05x0IQcwy612VgBRntph8Emlb0U3cWw
	Ruv8biF0xokxTf3K2Nv+eVgOo9yxuM1IrSye29wTbE9AxL7Rsr528bArWSxnTZNU
	GteZK0bzSgSKu4VTgooc4KbsaOUs3yLQN+HawA244cKhE6A7YAoMiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5t6dj5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJ7b1U001818;
	Fri, 30 Jan 2026 21:00:00 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjqtn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkMB3YEtvywt/L1Zm76Kd+5naxHbDLSRJOOooHatY7aGCCDiAq6QotET8uPnXkAbQTK6m1JxnVHKa2IZFxrvoAH4ym/pLNfgqdAFX4u6hJarqK8I92wknHVvXC5WuVIG6KBJvb6uqTkdqNqudaoASxy2R7VEdFHj3zjAvWqZWgWB9eQHQFijJ5sA+DLCnoJbOdW0BP2AsWKW4s9jdn0D1piIoFQ1jRIlr3Ez3ELFfKja4dYHpuRu1gxuwRN77vSZ7hOd3f1U8R4tFXch6hfJzwXLoeFLzKAjWsX/I5mCZvcIAKlP47ITs2a17eksNWM7UeNlXY/jgVvrASCjYOP5ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gg4j53iaCKD0KGWq8T3PWEEPapxaZjpkAJqf5ZsUzk=;
 b=sZyRjrUS7uhhoCRVb9qOOAM5i43uh44vG4DMah1sEQRMewHLYKfjmmRH/h5tnCt7d9Lqwhk8xUIcybItuAhNBpx8KwhSJF+dZfi/dGYE4LUBczbpCuu/tnfGcshL4/dbGnWUiNUBZmNrZtnMr0O78DMLXMqWxfltwx3QCdNLpo0pix8xAJ462iJvYIg4joDd787oI9qcp7VGz320e51Sx+sBEcdvA0jtKE8grWh5mlD9H33TPh2EtUFAQb4RNnAp2UK3Q19gwvpP/ixFPNxDphlYY6jmZ2GzFYz3Qc2zBwzLRN6c0ZdfXFNcdF0AxHNYyFarbBuc8MYvZN5QSdE9Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gg4j53iaCKD0KGWq8T3PWEEPapxaZjpkAJqf5ZsUzk=;
 b=HKo3ilTAlDOnT6cNc3+PiTLffyRlDiB6lCTyepfM5OBN+uBTdn6mz33cvQ4r/Rh7jDwCr3pdUynxhK57gXEj3lBLHFjeeT7GP/gijwpmNY8+G5Og/NVxXRWyG7dGfZubhjq8J8DfibPD1SN3Jqn1bat0LTXULk3KffGnq3fgIo0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 20:59:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 20:59:55 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 00/30] maple_tree: Replace big node with maple copy
Date: Fri, 30 Jan 2026 15:59:05 -0500
Message-ID: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0054.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 202bd95a-ee0e-427d-6fb3-08de60428525
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lTdvBpMq8t/DyiC6f/49LQnP1yzexBfEzCdEIsUtkJ0iH1aW52WJJczwE8nB?=
 =?us-ascii?Q?LhXptLvgOI20O9+AHsU/ne+LoXIzfdlq7Z/6zYTc9SGDgUTItONE77kfZegK?=
 =?us-ascii?Q?qKpdR2oZWaM1udjQwowizDkG9FgBxgALGJYb5WQ7LiQdEJ2RV10hdvgIug5U?=
 =?us-ascii?Q?bNvSjufpnl4csFTOFmnDt+hV09NV0dmVIwjD3EjKMQMi6L6fTh+tgH2Hx41x?=
 =?us-ascii?Q?RutbaMgSuPAzYVOqL6PjDMepbaYdHD2LdvSkTBrnHOShH8uyjavj0+901vBf?=
 =?us-ascii?Q?MWoD6WRA/dQgGs+TjxbtTSg40qho/SIgegFwNjUOa4K5ew5rtUDHAPGCX3HJ?=
 =?us-ascii?Q?N/n//BQmhVYA6DpjdkjodVKpc5OBnkNsQReVvtmfB6m+TxeMVatYWtxGl9eh?=
 =?us-ascii?Q?ajoXFqvzYi7DI2NOz8sTJfaHcC0PtACiQlsxzckBrBZuOhIbUUttGyudH5vf?=
 =?us-ascii?Q?wUzoS5oFJ3U4sEPMS0qH8S2EVrytTnx1fG19uLudDXCaizXPCjtpG4hedsl+?=
 =?us-ascii?Q?g6AVwOjBEI4KZ2CFzDLalXTJG2hesBR7Bu4rBUdBIWtAoWp8EAM5tyF/jvPq?=
 =?us-ascii?Q?rAdJzRx9ttyO3ug9wSnzEMEa1zy3l6PDldCV6FDkpO8m692B9lS7pcWyvzom?=
 =?us-ascii?Q?Px9GQHzPZkQbiLb5/H5wM4qJQbUG4vzWk/sWKO8WA63SKU4RVIocZw/R2+d0?=
 =?us-ascii?Q?d8q5iIKPzzSZwYCeSUNZCyVWGz+3DBBRtkncxNnbhuqPpLQ7sXJ8CNzD8XHd?=
 =?us-ascii?Q?HIfPzhiGtUG4uSAI9xKwCY4su9UWD7SmvRWqPbu9F13X6Dk56C9AadqtZ8KE?=
 =?us-ascii?Q?Uxr5TZwedayltM17yoZyXKbW0HuHV9tz9z6AFbV7gwCp8s+KCQkbxw9OMmi/?=
 =?us-ascii?Q?ZXtqpt/7ATojsKgNX5Et3+5XStxwrqWosKcg5g2fYsi/joLEYVh8HKpbzy5N?=
 =?us-ascii?Q?yj8TfBp+WgQi3ymbtNuTXAASGTAK5WKcI1uefIM8g0+43DJ1HdAYG0IMUG2B?=
 =?us-ascii?Q?F8/pVQ6MJ4OmKUIGoDL5PdcFY2X8FswDOhj/NZNi3/OcB7QOk30Zn3rE7BhS?=
 =?us-ascii?Q?3QKC1PP0yDBdMsLhDqgxYbHC3AxTaAAqVKPUjP+ur29xJ8nSyRFh2ucA5j7r?=
 =?us-ascii?Q?LbRY48eNtaYx/DEM3y+vtB0H/lFK4nBgYNeqwRJRyh24FL+54uWHgOdrfnmf?=
 =?us-ascii?Q?hmAP9ScVJOO4TfzuZ00uJqmsVI2Eln6XlpPjM/ZELgO7+7bkQQeh2i0fYpkR?=
 =?us-ascii?Q?rlwdDmDIY2LlU/Jm62CPjIH2z0ODVuiYyzJ2DenGBu4ZPz0Noyi1o3r4ok40?=
 =?us-ascii?Q?2T78MzJFEaH5KcKCX3tv9dFbnYjWEvzVoLWwbO+ESbv0snJE0BFMGjbEcB5w?=
 =?us-ascii?Q?U38NbZKS26aEPkya7gg/gZu44CXMj+tYOLfjBhTTQZmq+amyCxS5ZXix+HP9?=
 =?us-ascii?Q?eCMICyGH4GHFTTJ5Y2Mi31Kr9zLAzZg2DVdp7VY7n5QRhMmQymqttFXMP034?=
 =?us-ascii?Q?suPjmV6+hhCmt2i9Tr4Ne6LjObH+778ktc5NkNK3l8t2h9BFmynp8WOW+Dun?=
 =?us-ascii?Q?b0N6mJkwDrK7Xk4EZ1fRLz0BrHA3u6n6qCUFm6vE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PeXNnhhIAsTygIWEvRl843/IMyQvORPGnYJWuU1R3wOOdc2HSDNGXAffqPol?=
 =?us-ascii?Q?Sj0fN61bDFgFvMU+2g/hulRlrTr2g3/gpwtbrQp/IQF7qYdORPSjiK86a2Ge?=
 =?us-ascii?Q?V7Dc6HwbkYFeBm5X1tCnzJvEEexOPHXLYCDgw276vh6iYHCW6+oj+jJ71Jfh?=
 =?us-ascii?Q?C8w2id/Jg7pmo7HR7Tc8GDJfMF1FJ0cwqzUJI/tolnaEZkndqbDT4op78d5Z?=
 =?us-ascii?Q?KFjGFfuvLyfgC1ygUy8XYnOKrVTKXzIcoCQttjYjVFkVZezwFmNGExzg8j9O?=
 =?us-ascii?Q?3tpjprZI1nJASmuSNlhaegFP5/POlMJuJ0oQ8cAXrm3yo94y7QPD60SwVhFY?=
 =?us-ascii?Q?zyY3dnzsLCbLZV1q/M9AkEsvnFTd31HiZuHXVGSqJJ43E2bK0D6+dR8ArPqI?=
 =?us-ascii?Q?DRLxq6EB9QEVlhBqSH/TNhCJtsX2/F9RZnJSFSD/vJ1FyzH+ybvkp0vQqd4X?=
 =?us-ascii?Q?gNvpMWz6iaREWDhRL8ctDVJSi4fKqAylK0pBZTHkr/LcsqJfmbqrybCKOyHU?=
 =?us-ascii?Q?1jB7LVt4nwEg4Kf8Nkwzc3gjBj5pWOBCu5wSEtg7VeuceQFtXH6jvsb2GyVo?=
 =?us-ascii?Q?tp0a5J6m/SSd6xlnVAIYzlmjN/sMyz5rM0mRLTCW7zcxaaXE93W7WzQpPxXy?=
 =?us-ascii?Q?Lw49lVpAgfr/Y1xMEgTWbNM+PLAxDkLQaQ70pL5knKcl/OYf8gPdOfsXGS77?=
 =?us-ascii?Q?h6YtE1ZQD+mQW1reuK6mRFrIf3kkk+aOUggtc/m879XmK9y58XrSjsk7hNeS?=
 =?us-ascii?Q?vnns8MZOT4GNlTxPRQRCLZ75NF6vaRgbl4Kg5i5OqEVqhRtEjCcY0uXYXA9q?=
 =?us-ascii?Q?ovV1SsbDCuaq2oEQwdLGgXoKUWP7NJl6urjQ8ls6dOkUo60+cnrtp2IXU3yU?=
 =?us-ascii?Q?WQlcan5yiDsFS0y1KeeBBmSbMqRSUcSLDcu+KR8c2VMZhlgFovJkQJjki75q?=
 =?us-ascii?Q?/NUwnB71c8p3C2QtRMv7MIrYgV5kUbfmLhpuwzKd4SKkzXUNAXZ008FIByQj?=
 =?us-ascii?Q?iFwer6I4xutF66072octA3cTc+BZGt7SIJG2ahKCtiuvvOnWvjiyKI1lr0gT?=
 =?us-ascii?Q?Dd+Sb9u/6PIPnaX7B8dUOqzcqosIxuL9XLgeFwfWTZuGXxiRVLZZ4LZNb3XY?=
 =?us-ascii?Q?u0zmGsIFaFSFamX1VAHGZj5LNDqCgjpy8DfixvV12KIybFS8PFlf9BzFhRZS?=
 =?us-ascii?Q?nSkLpK/rOsQK5muJZj9uRTCmSyruYO8DoXdrpgkri2mljPwhMPLmjyr15pe3?=
 =?us-ascii?Q?mH4Gv/3+dQurlrof8vj6vaXX6cM2bt4kGuOoTHu5QmXJqjzFpeyPNsOEJVTI?=
 =?us-ascii?Q?r+pq/Usu4LWs4nZlu16CqdJROYEV5PwXPYXG1muuTLC8lF8BO3YWev3KoT4i?=
 =?us-ascii?Q?ow4WiXqXxoQhiyH4V5JlvlQfTWU7scH7xOJ8W5jm3fTr5SH/BFowfCXNqBbW?=
 =?us-ascii?Q?02X0/b954SwydUjzTu4GsfK7ZIpEOT2cEc+O9FKg67pZ5qTVx1U04masIBZq?=
 =?us-ascii?Q?I/z7psgR046prkfM+616ZtjRk1lCwVx8YMMMfloxtA+KlQXxj+hI8X7/gP47?=
 =?us-ascii?Q?nFTqCBg4C49FN4+MFf8LRTUDiceIUVZ2TbVxAKx4KoThZqMlT8lvwu83bYSM?=
 =?us-ascii?Q?MLD60Ytt5rcaYZASc7oyTLFdkBMEIcaBrIVhD7KbDwqYkbiWlpEqWdWIRyWn?=
 =?us-ascii?Q?Cr7Ay947a7XIV4ZAAXj/0K80Xe0pIkr5J0AwbVJR1PLvAltQm831iZgXbjsU?=
 =?us-ascii?Q?Qu1a6/nCHg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B4XrOvYAi17+EOS/Snq/q2jpocj+P4C9ZKZE6NaYmVMca/BAr4xcT51s19nl6u0d1TCqybNYfrcUCXLn4635CU0yt5QL2BFmlSyQMEhFHdGmmBUoKuma3tdjZRKxEbKKX8nOzNP8cLV60gCJ/M7C10GowYtnT/wBibCelC/bS3ZbzAlVzGHLiBDmU5Nwpjhtr+BfK02nBrg4XrwKYKlJwvZSbWPUxUIZjTbhWHbTNxgVutP2eCiDyQ1l+yVH/Y2yYeo6ATedpEVCWc2siqK+Q+2uvoeMQgX2Zrd8taM9Tf83oGCTAyEpOlsYoL1IaYBatx9qjHqkOiOuO0349R/kptTKKqHiSewsbToIaL5lA4KBx2b0dk1c5ISMBtETVc7qQZNQNa9e6fmMyL3pAgQIXqTZrf2LMw7hKlN9NfC3IFzfo8qPlU85S8fWBp6ZaMeBMZ6mcKJVYL4JACOegY7RoNfrh9k6F8DdnbFp19Jp1tmv58MfJ9lfNiCyvlkOXtTVX3nwc2scE6BCLxorExOwm1KjIS+4wFy2/FBfitOiJPc1KPH8jrU2x6feeEIa3wVRG/EXr1Ee5b5CJdi/HyIwR0dj5MBXPzEsJ2stfasU02A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202bd95a-ee0e-427d-6fb3-08de60428525
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 20:59:55.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bx8m8YYHVsKXkOSXAuDCX31sgYN7jeglLN2O5+/BEuDSz9PcihK2NpxwP3p9PnIJ8sgySXtraBQ8MXgnwjDV+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: r5ioipHESYQ1ZaZib8AvP0T9NFv2CrH6
X-Proofpoint-GUID: r5ioipHESYQ1ZaZib8AvP0T9NFv2CrH6
X-Authority-Analysis: v=2.4 cv=IIcPywvG c=1 sm=1 tr=0 ts=697d1bd1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=qNABUOcEAAAA:8 a=AccYbpKY9h2kkeqM32EA:9 a=Ytm653ucTKQjCvbzLygB:22 cc=ntf
 awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfX2X3OvmqXhWn9
 d+V3ODLr+wD7i2GvDiW1986f7LIsE9sZizSRtdUPxpOM7vEnwSA0N25Cm6zzH1GIfSEvVoY8oRe
 n4pUqKyogRiF3r0tm0+JKob27cOWXbMo9KaEJax7Lhg4IKkmGTWrRg/Hw6nGMuvDgs1D4cxX+ke
 qzouFj4UyHfuWtCIUVJVRy4cw2Wk5UDwwfP1KYxdXyxUtoJnmXb4xi4suqWBA2FpP3EyIC2rqe1
 91UNe2l0kEppa90DFG4o9XV4t1ccEAgUmMFMMtt1d6FxnYo8IqF0dF+wSmPNDtxhgmoB4BsZByK
 ZPA/fjA1CVcGLe9obwTybss305CdjdZmbYGlh4guVr7U9zTyOh3A9N8VEbG+5h0x8QoJEQc3j5+
 ecQq7Lex8rU47U2ZdMM6f9msVZ+L8/L5+kWDVmR7FBgsbj/vUMilRvskc1yZKK3iU6/7n9XWfsi
 ND6Xot+CykLP8lAibl98E94Lt3xIqXdTJeWnUMtE=
X-Rspamd-Server: rspam11
X-Stat-Signature: fnmf9ih6uazryeffgh4x5cjjaj6p4z3c
X-Rspam-User: 
X-Rspamd-Queue-Id: D8555C0010
X-HE-Tag: 1769806824-385207
X-HE-Meta: U2FsdGVkX18X0u0FGA1cdPAm6y0mTFvm4RGRqohj5XnEo+hZsNraLFv0mO+yCGCVBX9odbhpM7LwWUsWJuVhfVcGZu6IHG/2p/GQht5ekOfhaxrTVUpgAESbKAJwZ8nTGRbzkcqFhaCyhbICZjJD9x63ncLbHFUkNJtqGgQ3vImw8jT9uPd1zQUcgyOY+cvO56mW0TuiS6PAgbVnWsccgQVZRq/nvBILU54jh6PWflfO8ARsOjIQgEh33eRd3rnbQ5liMMI7AeEXkddBvHQzdoK5yGf1knW5bqhaw7vT/FpkL4lGtn3bAd3nWG0anTXxTM0c5FFMdB/Q6ALW0BsqGvIP0sMHwfy0JDfSBNI2tBKxXvcUauyvVeIxlHfPrq4dlY1F462iNEYVGeEECkt33Izc1uD2aGnnVXMknfAnVwQ0D5hNQk7F/N+oVn5/p5poPbx4U3HCk/aoNQyisPEQEiU0nYJl9NNGpPVG//kq6Ge8cbAkkEtPSnB/+GN7ndJ/wuUxc0TJlt+KVG5+ToyXVJocLK4pvXN/ALY99E10tJg2dJMIvdGyBZQhxtoPykzvHk8gJsOjNeIcrryS3vWfDgIFAbynwBLk3/ep0s23620cObPVzX4xGvszbVZlLpFI+ll1hGru6RSWEus4vgnfpiabict3zGWOLHBOtsCDk8ebIEBcojVf6ZMiiCZUOKHge5kVJprXtIgCRlYPe95kZgyRgJSCSS8kTgNitH6Hsdkn7jlxYsYaDQxv1QiiYhSfXwDMl9xYS0quQLtbdVfdqMaLGD8zfJ4ZDQT9GUIz0WJQujICDYRYuQg5TE5jS64cdAF6myuTsz7cbaHZu9CZQSF+umy8Fz/H6/rMYilWrwt6L1Jk3aSz+ImLYdIaFDSyCO2mV1rRikcwqCn5KTB6l1SY20kNxjpggoFQtgut4ddr/bmD6k8FYNNcWWyUJPvhavFOzLM5CWZYMSI1qtK
 XRruhKAe
 n6x2+Knax2yvu54wv0PMpCOrVMCOaHSP8/p3wJnvr0ziKqTX0o1iiwB++XIjzmIxfbg8OXdvYPq4AwGYwfPefgTadecJK1QuDsFJEaPmBlFEcLUayb7FA567TYw+jYs3oSyp9+438SrkfCbkb0P8y53NTM6HP4W6ZcFC/5IgDdC0Rvk4nJX2db5lBt22YOscPXnwCdYnOnhr4Hap7dXkckgm0KICWC3L54Dp9eqllaCkUXLA1g0G7Mr5LV6fEbByBy5t2G/o+asDJSBv7UMhNeRVIPXE0oK1yta6Bi3kZbSSOVbI9Z4YiU3Oyfk95Is2vkhIMzqqKxHt+Y6iLE4RVQDqgHfVLfaMBX4IZrstO+bgLS2YvH/uKnIRaZzFQhj628wsT41xQ+1kiYNj5FEaoNJsmWtFtUmfzQjR5azc9Lyj85RvD5CloLpGmDKP9RsTmdH5a3/ilE/I0qsd43eU81+49y6DAPf6lh39vW78u8a72JRFC0iIyA1Pm1nLKyKLgoX50vi2zt0HN6AZ01ymheN9VeWZG5epWGHQ55lrblDbz4QcykB9/1WdlGlOH0xS5TDf+APiVMIIWjklDrrSctBJpE62toKj4WW8KiV2twuYxDcjSGQMXEmQI9QFvawrMVriG3h4QC55M3k6do0KeH0w/nLQ64ParU3EWro2OtoZnSkP11i9tuQerbwne9do4uQn9sjmJX3Yz1P+oqOuuzMsnmmd1eY4SUKMXR9v2i79kdQXO/OZ9vPW8PZovPIUXm5E+0rvgGUsoyeA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The big node struct was created for simplicity of splitting,
rebalancing, and spanning store operations by using a copy buffer to
create the data necessary prior to breaking it up into 256B nodes.
Certain operations were rather tricky due to the restriction of keeping
NULL entries together and never at the end of a node (except the
right-most node).

The big node struct is incompatible with future features that are
currently in development.  Specifically different node types and
different data type sizes for pivots.

The big node struct was also a stack variable, which caused issues with
certain configurations of kernel build.

This series removes big node by introducing another node type which will
never be written to the tree: maple_copy.  The maple copy node operates
more like a scatter/gather operation with a number of sources and
destinations of allocated nodes.

The sources are copied to the destinations, in turn, until the sources
are exhausted.  The destination is changed if it is filled or the split
location is reached prior to the source data end.

New data is inserted by using the maple copy node itself as a source
with up to 3 slots and pivots.  The data in the maple copy node is the
data being written to the tree along with any fragment of the range(s)
being overwritten.

As with all nodes, the maple copy node is of size 256B.  Using a node
type allows for the copy operation to treat the new data stored in the
maple copy node the same as any other source node.

Analysis of the runtime shows no regression or benefit of removing the
larger stack structure.  The motivation is the ground work to use new
node types and to help those with odd configurations that have had
issues.

The change was tested by myself using mm_tests on amd64 and by Suren on
android (arm64).  Limited testing on s390 qemu was also performed using
stress-ng on the virtual memory, which should cover many corner cases.

v1: https://lore.kernel.org/all/20260115193647.1695937-1-Liam.Howlett@oracle.com/
v2: https://lore.kernel.org/all/20260121164526.2093265-1-Liam.Howlett@oracle.com/

Changes since v2:
 - Whitespace fix in rebalance_data()
 - Added ma_init_slot() for cleaner casting during RCU_INIT_POINTER().
   Thanks test robot & SK [1]
 - Fixed off-by-one in rebalance_data() which caused node overuse,
   reported by linux-next. Thanks Mark [2]
 - Added new patch to reproducer to test cases in userspace testing for
   the rebalance_data() off-by-one

[1]. https://lore.kernel.org/all/20260122055516.69335-1-sj@kernel.org/
[2]. https://lore.kernel.org/all/bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk/

Liam R. Howlett (30):
  maple_tree: Fix mas_dup_alloc() sparse warning
  maple_tree: Move mas_spanning_rebalance loop to function
  maple_tree: Extract use of big node from mas_wr_spanning_store()
  maple_tree: Remove unnecessary assignment of orig_l index
  maple_tree: inline mas_spanning_rebalance() into
    mas_wr_spanning_rebalance()
  maple_tree: Make ma_wr_states reliable for reuse in spanning store
  maple_tree: Remove l_wr_mas from mas_wr_spanning_rebalance
  maple_tree: Don't pass through height in mas_wr_spanning_store
  maple_tree: Move maple_subtree_state from mas_wr_spanning_store to
    mas_wr_spanning_rebalance
  maple_tree: Correct right ma_wr_state end pivot in
    mas_wr_spanning_store()
  maple_tree: Introduce maple_copy node and use it in
    mas_spanning_rebalance()
  maple_tree: Testing update for spanning store
  maple_tree: Inline mas_spanning_rebalance_loop() into
    mas_wr_spanning_rebalance()
  maple_tree: Change initial big node setup in
    mas_wr_spanning_rebalance()
  maple_tree: Introduce ma_leaf_max_gap()
  maple_tree: Add gap support, slot and pivot sizes for maple copy
  maple_tree: Start using maple copy node for destination
  maple_tree: inline mas_wr_spanning_rebalance()
  maple_tree: Remove unnecessary return statements
  maple_tree: Separate wr_split_store and wr_rebalance store type code
    path
  maple_tree: Add cp_is_new_root() helper
  maple_tree: Use maple copy node for mas_wr_rebalance() operation
  maple_tree: Add test for rebalance calculation off-by-one
  maple_tree: Add copy_tree_location() helper
  maple_tree: Add cp_converged() helper
  maple_tree: Use maple copy node for mas_wr_split()
  maple_tree: Remove maple big node and subtree structs
  maple_tree: Pass maple copy node to mas_wmb_replace()
  maple_tree: Don't pass end to mas_wr_append()
  maple_tree: Clean up mas_wr_node_store()

 include/linux/maple_tree.h       |   42 +
 lib/maple_tree.c                 | 2134 +++++++++++++-----------------
 lib/test_maple_tree.c            |   55 +-
 tools/testing/radix-tree/maple.c |  308 ++++-
 4 files changed, 1340 insertions(+), 1199 deletions(-)

-- 
2.47.3


