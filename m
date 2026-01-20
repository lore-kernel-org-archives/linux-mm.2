Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D46EAD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 07:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA6F6B0379; Tue, 20 Jan 2026 02:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1D96B037A; Tue, 20 Jan 2026 02:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FDC6B037B; Tue, 20 Jan 2026 02:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 177ED6B0379
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:48:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1F99B9913
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:48:56 +0000 (UTC)
X-FDA: 84351565872.12.4A59717
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F0751C0004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:48:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DZHwt5hx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SwcL9ZjS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768895333; a=rsa-sha256;
	cv=pass;
	b=ZWpHv4810Kk+qQMZnTmoebJQbhZky7xSyTjaWfKez8MVQPWVF+uML02fDx+HREtTgBbE4e
	7z0ui/7Rab3thr2NA+H6FhZ4ck+DO7gsm8ddaUfCDB2MDEvn+BkZybArQr1db47a7v/MF7
	dxRj8oMRZAp85QruMcJwz8E8jdv+ONI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DZHwt5hx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SwcL9ZjS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768895333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cloIzbaOkrY9axhBn1uRWWprtfUmpGdi9ibaraG31n8=;
	b=CR0DpIoC71RDAufoqDroURETOD7r9lDsB5XS6tO8AI9UtXIqVFqcXvuIrCiezMG0u3Mow5
	KykAQzIaGVdoJOYF2wwP6VIyLMM0z30yzi/PyQc8gNDHoMr/vQ7Mea4P17z2g7mV/6fmFj
	Psqh9nzCR/jKfVvnrkjupJo7z3LZEaU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7KAoq1034800;
	Tue, 20 Jan 2026 07:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cloIzbaOkrY9axhBn1
	uRWWprtfUmpGdi9ibaraG31n8=; b=DZHwt5hxLvaQe0ggNYBwApzDcIFg+cyY0n
	WFZH6hFTtYlIMwZLWkocqrBBLPy/5OcISAVjcje8+AifKOQYpUW59o4E286qEhIp
	fJlIkUHSWylABD4ohiIFVcdGlufCdZ9M93P86cw+tvLmdRSg/qTG9yoayC+V6Mz1
	SETWK/1sNFk0clTL7e8Ur9oAvfzwoUl/TlV/OCyxhpo+ui1bZPm3BPb5KI+T0o9W
	v7YQaoRNLdA1c2SUE1E+CusHJoQgnjcgGkY2IJ9GOuXgTer7HEiIarJFYfkZG2lA
	sLUf6JepoWGgmLA+mbfVsmx2HyACPGbIPh6yUIwLuUYSVJaDEi8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vu6rn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 07:48:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K6eAqg018939;
	Tue, 20 Jan 2026 07:48:28 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrq2yhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 07:48:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xxB4p1F+yxsaU9qMxYwHT5EuhC4lQUK566N43lolq/l0/8tuduiv7VxEHi18Leyw2TT+y6oh8rKJPASXFEDKm7Dl3y4W483k76EiEGusy41XRCgwyg7TtQrOWt3ekR9SrxaoDPJEgr6fJxl8IY7uSU6fCHnv2n+qlI5Wr77YloBH6/NqzVhZeCwpnacqBfulPkxdqcfPhaXiaxjpzV9U9jPWhtQFeK/RGn0Ewq47emscXqKLGJ23GaoOtYBoomA9/FwydZuk+IWfYtJX9MMf2JPaUWX029A5HyRbfnB/pgoKsPifJIg8+mFta8uVGc3hyf0tGHteblpKubbHrQpkdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cloIzbaOkrY9axhBn1uRWWprtfUmpGdi9ibaraG31n8=;
 b=viSuo7IkjFsrwcoKxX5LGoN/09/NJB1QT2CAuvLxA5a215qIV2pw9Y5tvLg5H63U6Fhm0DYngxR8X90sB8p1VG45HCjRGLz6rtoSc0K5fOrljajpRTyZhiudVAdf7/2dHkd2Ei+jWwJKWahlIjDbk1aV82Oz1Mw8sLDWaQK+KPBP5XALIDX9lDtlxHVqvW3ZG1jZK+8Mmdqmo+GMJZ7cevoihEy8YxH12ZXSmkgBNjzfZxGWaZu5MtS9FXtM7X4ry8fXStCiOW5948taZltBR45wPlHzjjyi4m+qSg0wpS+R6VJpGUyMxOs3lMIl+8t0XfhQ3kRi7oGoWfeyU2RlIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cloIzbaOkrY9axhBn1uRWWprtfUmpGdi9ibaraG31n8=;
 b=SwcL9ZjShNk466wEoupLoXl1/HrFh4IJL0wPLYfeDcSWyOsWButHMfsUBzkfoEMqrvh+TtQN8DxryaGFKT7B3MEnAiQuHNyAlNh/uXjPP80psIZAJm1QFgoGTkiLxkHbb/npJHxuSbD+OBSMh8rXeZ57VnfFRqo4Z0Y02KdMPJo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7182.namprd10.prod.outlook.com (2603:10b6:208:403::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 07:48:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 07:48:04 +0000
Date: Tue, 20 Jan 2026 16:47:55 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in
 zswap_compress()
Message-ID: <aW8zKw5Ida_gKfQz@hyeyoo>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <592f65bbe05587c01a2718443a70e639cc611f3d.1768389889.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592f65bbe05587c01a2718443a70e639cc611f3d.1768389889.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SEWP216CA0020.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 080e4e3e-d5f3-48a2-310e-08de57f83e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cmqHUpJycmG4KDLjWB93oWKQ/0y0FoHmdhmm+ZJ+m6TCmlFePpn2kfsgxvml?=
 =?us-ascii?Q?VRWbDiUSPhCqUEE06ymIycjEqwQpgxWCbQlZspBgeqNB/VddC3GXbXFRPeZ9?=
 =?us-ascii?Q?zXdNz/QVnElAGer2njjcJ7I+F3fc445E64LaMx31mNuXNPSV8C/+yBWyz8xI?=
 =?us-ascii?Q?os+Fnx67cDUclX40ZAbW2JxMLXSEsfcP0iHJgVDiOPfoeNm9KqqpN10aM8Sc?=
 =?us-ascii?Q?HSjSoGq5APRTXpJ4zFI8WNuZdPVc5UVUirDNRUCXKQ9v6hy4AbpmKpzi6udY?=
 =?us-ascii?Q?Ax/9JNd/83e8/rEvGpsE+YePsDAKjGjn+MDJj2BGidntbagAV2788NQ8Hcyb?=
 =?us-ascii?Q?98jabKda3Wa5I55KNFUEYYuqO+Hc7DawZF6bHQql9I3iHzGqEEok4E32GlDL?=
 =?us-ascii?Q?t5NCcH4WoevA2qQC5ljzXBLS/Dyu0cXnzaXU6Jr5z8p/V+nWu5iaK5wWQ80Y?=
 =?us-ascii?Q?gVRvoNei4mtv6r3VvwEBnIZt2JkLduVfRCh80ufYBtH4QlAcBVKYIILPkpTQ?=
 =?us-ascii?Q?Zeo45ba+byxM+MyJF63vdFrNGYOvDZwx4grzmo4w3+FYCCvfoWBYHy9CIRbE?=
 =?us-ascii?Q?evl7kyXskAYiMMrMT58qwjI4pnEfctb1tbwktXTVkw+w7RHvYC1hKxepLqhi?=
 =?us-ascii?Q?/+kibQIw157hA9GpPcf0C9T2aExDiwBfaynFddXL6H8owpiaebZ3rvf4YBLy?=
 =?us-ascii?Q?0lU4HzkKcEWdMZyOvYtjQxeXUchzNImfZnXyHpD9WzjZPvXDkgq1a4XFaW6Z?=
 =?us-ascii?Q?7CcvramPKpEITPmfuUY8dUwdixx5n/bUwEM0u/KNahIGoV5Wy6Q7wKxU8iL4?=
 =?us-ascii?Q?ntf8+J6TrRipjfBLuxzJCzKbrGfyAFwg9c8K9Kv5NIKPIfr2BBeb//QENqUA?=
 =?us-ascii?Q?jrHTFLrf9UYWUm1TOfPsNgmYAfssMSNKtVeGV+Ogvc9EQEsWXffaXk0s7xri?=
 =?us-ascii?Q?EAy43nIOjGKm+H/s8Pp22fuzBZ1+Fh12PyiGIC8E+y28K8FelFip2xazeLD0?=
 =?us-ascii?Q?qeuyTfG0P0JwCREz8h2Eh7r2QnScTza0MCbCtSiOC7Cdhivb5yJFwNtQLlwG?=
 =?us-ascii?Q?9AYRwVHQR/vaxh23vJKJjxRWf+KbTwt9kZiO+ZcLA8b36UlAqznx7v23CbbK?=
 =?us-ascii?Q?dOUOt1ovNH/UFnT7+176Wc2DrYk4cvLcTd1vJSsrBpiw3XhN3P6CGb34Tg8U?=
 =?us-ascii?Q?GMkFG0Mcmag2P+PNrn433rNNFa0GUGmDbJXyo6SzKebuL7JrL/pPWGJbST8X?=
 =?us-ascii?Q?Y4sWEwFpZiuEit08SjGXJgQO4B/VnpBmP2zhcA5kTk5i079j/csjqj5Io/AM?=
 =?us-ascii?Q?l86lFifaJC03xH1u0M2Dp3vPX37rECZuHkhRxntOzXyM+QlkxkODU/sJOzSo?=
 =?us-ascii?Q?koZMeUqI2AGxDk8hG2q/WNJfeBNL7IyYzoxOPrnlsygBvvb77DrFmt1KCCad?=
 =?us-ascii?Q?2gkrDWT7sJhOxe2buRb//cY8DQks5NJ6R+ajtYzaOoS4s5MneGsOpzYJ3JaU?=
 =?us-ascii?Q?v2IY1B1FCn/87SSaUJcvNj4ba5uM8ZYQ0Nle3mus0cxcwa3uL06rJox9c58h?=
 =?us-ascii?Q?6RQslUCYdt8TVp0WbGI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j/MtBSsMA3T38htICmmtJIcx49KpflXYc6YjTVrOuaMjy2vQq+lhZBv2/wus?=
 =?us-ascii?Q?Ex0R9SXsVQ0fQB3E0OOvXkfA9wqp/5ZLSrc/EOev7j06XSqTpq0FBMcAbO7b?=
 =?us-ascii?Q?sOakut1qOKf82HsIoJ5nXA/gJyQr2xAw9Bsx8NiB6qYKCnDZQkqcQeY6hfIv?=
 =?us-ascii?Q?ml04NKLZLwZY/Ua7JoQiY+p4ajsSYn5/JSJ9200EQq4J5p29T/suBjT873Yj?=
 =?us-ascii?Q?KHqt9Bm7T1QwWt/4N7VVJq7s1LugWZd+MN86sCYKEMupxlCeCXLjNUnb02Uq?=
 =?us-ascii?Q?4Rc9H6cYmU5rbZazuWIJoxq4npVEG/mBqH8Bp8vVpA4RHnJR6xhdnsZ/hGlw?=
 =?us-ascii?Q?iZ4KIIfgWYLqCPoM5bxIdJhxTxHg4eaYHNKblzSVQKMuwueRSDn862NyQLla?=
 =?us-ascii?Q?0iyHfFcj5HVd2AnU+w1J6cgZBd9zipR+rTABb5fJs75gpid2lolxv6AbsQ3i?=
 =?us-ascii?Q?nS1q/rLeWj128590i8CKZbQzgt17LYqjUlTjkIswawKlD7zuqU4SbRacO1ei?=
 =?us-ascii?Q?O/nofXOZw1FiQX2rRWKOYLVMJp4IVP59msclq2vhP4hDKXlHBTZqZ8p4DdMj?=
 =?us-ascii?Q?kLwADGjT6/Y2DOmcs8CoPCzVl8LyzEQ6pmN9cWMyx2g4k63mqiuIFY5jUygl?=
 =?us-ascii?Q?EUFIZZ00WGuQHFCPJsginHm0F18fFPbfmPXj1Pi9s97gmVUI/9irEIlgyC+d?=
 =?us-ascii?Q?tKCK0SzruMLzP4hEP8WHTjmO5IJlsAiubRRJK1GtJ/UzWLFJUdXeG3fWjZ7R?=
 =?us-ascii?Q?rIity/YvkUY0aR6AK2NzbTQEVplxjLDlq8XCaNOtAPiub5XN1eGLy5OrrSRF?=
 =?us-ascii?Q?3oHOcMxIaQ6YUwZiUI/BZXbjhikJb0arNmAFEd3QQawnv8NB0K3iSiRTycCr?=
 =?us-ascii?Q?1QPsQ6KCpLtParEN+ukMrye0vQuCqt7MPo20eVXv5xMb51sxob4iosVOO/I8?=
 =?us-ascii?Q?p8rrJzQm479gSuxkdQ5834wzoFuuQCx/opjqmr+6tdsL86lWe5t7Z1YY7Wh/?=
 =?us-ascii?Q?2LIqj9A/xHKVHlgvjDIKLUY2+Ouji5kbTtckJf0eNY8L0gl17ZaGdrSI6UdC?=
 =?us-ascii?Q?DpvcIyIig4OE5kYEd2NQoC8YiaY6MxYzWZc+LH973XW6uvTvOHArmlI+X/5O?=
 =?us-ascii?Q?nvD7ZLCbtVRm1GCpaG50bNb8l9WezEphtS9fwtHtIatzfBOLGKui9bVCzfeE?=
 =?us-ascii?Q?YG8ifnHGJixVosUy2BrrqBzwKGY3bvIvq90lRTYSeO49t2biyX+5xDCH2T5f?=
 =?us-ascii?Q?wUet4WP8uLatHfxSlpgYK8P6x6KL1Kq4aNx+dHZpB06aWy1txoaDP0MSgaWe?=
 =?us-ascii?Q?wiy4vAepA/HC/f6biUoEUNH2W1JRGqg2iE3+y9o9c2HzTPQuiihU6ywvxCn4?=
 =?us-ascii?Q?9rJmuTFTngy6pSvCJdgIBoghm17ZTBfT+aVW4x6msIhmldGB6vV4E3okT/cI?=
 =?us-ascii?Q?hbXZHI0FJiGMMK0ZNxDQTaaXzmCVuh1iGPgkQlpU8I5eXBJymG6lVGaJqiiA?=
 =?us-ascii?Q?eGZFVW4XpUVh2VRhCTHNaGyXrRQed6XT4+ME7EnpzyDmhR17eLVguRwdKpMn?=
 =?us-ascii?Q?mArv7wHz0d5loCPacM5bnlkWYA8iHcYRyEeIfjat4DGNMudj59s8obQcodtV?=
 =?us-ascii?Q?2U74PSnPhBRRvGI+y0o0nMNSTyB/iP+p/sz6fVKuMJOlZtvgRGCZaAauwi5H?=
 =?us-ascii?Q?ZFtJPQHakBUL/wBrTVs4Uvb8lJdcAROa7UZQb32wfxofD0DcmUBbnbg0sIXK?=
 =?us-ascii?Q?TyoQOb55lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gdr5LbN1Ko1ydSMuiQFP4vXs7QWiA/EqWWaSXVuS0GDuwnalXUXs7pCK9g0V7vF62CtAra5tUvjPkqpLZrQfQyRqSeAjNZxJwetVDq0Mh+5saNIZ3Qmb3p1DBJeAZacPx7UdFaQPII5ymzuCN18YqqK8kVa3225KPxRMk64yNj62FCaEIqzjZpO0WLdWMnDaEAbBQ3ACyNT34voi0FO61/VQTcJKguTm7EGzbjok1yYoznFnGThX6/yAVe//mbJtpBlWj6nro4VEOAiVo/Va3obVWU16T1mZtni+XNUofCsWXLg09kde2kRmFoAXKC6U2TLvCcaYWb1uf44heBuyX67gvO9z2hLOB1VAWrNcr/+Ow3o6QfV/IXst/YaiCNzEDUba6xAxFaiK5rlF5Q5FxIBpjHixcUAFxa2xN9063q4BZwmWuA+TTUb9SxOm81cwX1Nx/z8LmDfgiCT9pz11fGIwuNUrj/QwPED/zWp6zorqRmnh29mb+wdxAlfEMds8NqWyWJkGAdB0Sq6J3Br6FhkAq6z72pjTIabMJVX0AtCKadEzo3PnwdVM4TVCCRrQBSF0AjMlTL5rZ7cHyEAjOhv5sl6QfGN2aEvOxWz6ECA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080e4e3e-d5f3-48a2-310e-08de57f83e1a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 07:48:04.0882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jk8RXl6BlYzXq6aDrJcUvMPnZeUjpYzFBc0Cra6wTh76MSQvlIN7K7CE2cdIt0Akc5+uyBe9MxNZ6nWwmRP/dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601200064
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=696f334d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=ufHFDILaAAAA:8 a=yPCof4ZbAAAA:8 a=SoCXcYpnAmTxdRwB0ZoA:9
 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10 a=ZmIg1sZ3JBWsdXgziEIF:22 cc=ntf
 awl=host:12110
X-Proofpoint-GUID: 2RKD1_70uirXgt_OZDl4gJrWSiorm0Ps
X-Proofpoint-ORIG-GUID: 2RKD1_70uirXgt_OZDl4gJrWSiorm0Ps
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA2NCBTYWx0ZWRfX5LDaZRdKWmgl
 qtDrIbHEiMhMW4bQ66Q5yG4BVwZ5jSnvbOLhb455kcYcnHK9HPItkZ37eom3o3eyruWs8hl4uF1
 jyPI99nraVgksl4XZgysew9X2WgKXsYDjsCfhCGDJ0ZM5UmHYDgb0luSpdX4vEVFEIiATxUgNwd
 l9mIy+cz+0TFkls/l8b50b5iTgjLX7PRN5V3+XDyTdKbn+KZ5qhB8pi/bP/yGjFJtZuaUHxKuHD
 5YWNbICu1TZomip4fnPxOMxI37Xa03rI2xK1aKHeK2A8Jdhw/KWxeiGfF+XspSmdn6vOmwF+hwi
 WtzLUktwTzCQCsDzdcMKxg4XrLjY9vhacgPOne0ULeIOY+k4Ea7VO8Vc6f3jaOtYa4VlstVOB3C
 sdsKLYVfRA4mB2cgIsGWf2/8ShSaEvdVaY4WS6eRx+LPcf9VdQZbMTxANQuXdl8Fyraw2RwTucv
 Uyh0hAZvRa6BXfIEZ+6gypc6B0iOYWJPuAXUvzio=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F0751C0004
X-Stat-Signature: h4cx8i9y4fwf8ohn7uaqjmpp77arozy4
X-Rspam-User: 
X-HE-Tag: 1768895333-503088
X-HE-Meta: U2FsdGVkX18TgHsJ9NUQV3VL4SNz9hj2kRJfol815XGpvBuXt41APN/5VTidrp6khEMkh3pb3D5u4rgM4UG2+RKZth/gxzEHeZ6VkD3l8oT6pDE6vK4ss3qS5GFsrMHyz31Y3hDpyZa0cp8NMijlf8qmLPZnz2vTX/XlBd+q9OwbwFBndaCkaZDcjAQwvh/Vac06wu3o+Rm0FgH45nY7/IpcEwypYi27aXdMH2iLyAyWa+zpEPxVf4I74oxtdj7DGBJiDyshXNh/qGX68vmikUjGmIVDGh+iOoawFlAgnDPr4C8W3oJMTsZjKGWGHhmh2f2Ye+73GAF4VOwqT6ryUTLBNMC0P+CiH2ldKt9/LFLlrVpVFaVSk6H8j6c0scwoaS9r10yCkdGWbT9g5GTUpSKIMk0strLO1ya0ajuK0/cER4N5ZEfMBi/XDZSv3bjpSVMRueSWPF2CLkyOZrV+vH0/jbTJuu3VZIIT/tYwBkdCxyGL8G1tUtFVVkMLf6gMBERREbEP0mx/70uaVbn3MAjX4lA96fgVStyrmr2NEh+BVO3RKWOCD1xDniQRaBD2n+x0P7R2KFVYMFPUiIjYHWpPL3Ol2X4XdDkxDqB/qdNpSzymaIa3qqKDbMNCDNoN3VZLjSCa1LOFKe+4Cn769msAMgIApl4wYtqjki0WYlTnVOMYlH07RR/Ay3uC+ewzntwtiuIQYafKVKF4Q1PiXjdwDm00NVVevgnJqh9+jYxKrcFGjnDfdbJEC7uNB1tagG4JaizPsvXCkWGwQGzr59fleP0/gSmAN0SmSMtHOyzDtsvfaRuqc5h8sAKlCOuthircafRPIp0fJPsYJ8HfgqnEn/l5q59mOkRR89zt4aV7ngjo3IxSPTZrpsOBNdX9SU/j1IW6UXJlbmBtWtMnk7WqMYkDqYyEFm7YhGfklDr3tnIlUeg/WcvJrqc/hhDxLKnYK7NuDM/Xi7arpJK
 laETAyj2
 36xOkMUWb8hswoSQEKDt6rs9oCViTPcj3Y7ZdMEi5UauchOB2p2gQo5EuUl5o++AlZZYtxoHGJxVK1xO+3TUC0wyX3Ax0HKrqa/QpE07CAYlIdVfQCK1PUV3V3588OioIHENyv8jzP+QISyg3vw5BhebPPgb1wSegnDjlfIlplp9pOn3tkU1EdHONcDyTtQ8OiKVv4VIxd492VZQLHtuUSXqpQlusG+TX+bzR0re9w+WSmpkTcTELFYKoUdTZ4hCLisTd4CES5LsRqhl+jCf2DZnQ8ZxI+NwnzridK+HQNcs3t804vOwG1W0x5tWPuPdiMsiL5llscu8VIFzFd4ZdyLsAoTeWOLOLFRLt2G/iDPUkTpz6M2Bzn89sB4eqAlQ6T4i4Fs4l8TjmemZC9sj/p5dRUANHqpAQ8XDcevaJMx8n4LvuNXFZvdtDBer7QfbCYupLI2i156Nc2LJkhHdF3vZLM/FNfshZOmrs9zjMZxxc7Dwvag0lzx7txARulb9qWGTBwql/fo9KoDRLZND4s0CZFqBUgsaWxyGWfxV3g6jrA+/sv70dfn11hesF8gP9FnwybCLwS6UZ/OSlPmG0AkfuyT8l8kkNy4Q3CVoNjN9PJweJEzIyukRnU6hfH+svFrX+eLsoJv0reed3aJSB3CHMp01jMlbxLn6hxrcctr2CRvEEbJ3GD0Jqzq6POnVAtDptyQgjudz+lZTd40im37medzBc5CpGwELayaFtO8WW3KRqce+/kMR56+atMLg2TVhth4h7biqENiyPp5Rd3RtQyrZsj19qixHeLbqnu7xYVp9Se/3wF6gi8jrPmGhzlk9ajAZkaJK8pSfTJmrsGjFUCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:45PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in zswap_compress().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

