Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C0BCAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3118E0045; Wed, 17 Sep 2025 11:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5456F8E003B; Wed, 17 Sep 2025 11:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371AF8E0045; Wed, 17 Sep 2025 11:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1CD8E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:25:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9ED41A05AC
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:16 +0000 (UTC)
X-FDA: 83899115832.20.876FACA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 663C08000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HXJ1aP0d;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CVyRzfo9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM2asB6V+oZKrPmrZPKLNrYs4TTbWhqxI2iR2+npYug=;
	b=U+I9WrhEGkWPCGXHG6udyUUJ+EJChDlMFHikWj/MdeWXIcShubqNfepZMMU++o/u74zCgq
	PgSrOO6UB/Zgs8QymD71mXV0wAjK/snmUUhABnJjfu5iuJxiAebkVX9TJ5xCPYmeSe2quy
	qYmJztSii9BkbR2xdPHZVogZuMcEgCM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HXJ1aP0d;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CVyRzfo9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122713; a=rsa-sha256;
	cv=pass;
	b=LT5fM652YxrHY9fgbcQX1+FfxvZ3utFHY4pbPht/xkpyQ6A2vlPL3E7w4+G4SKa9Az+SU5
	jzIKhuuH1qlTn8pOeG5JoEt712Y9daWyBnLxiYDZswDre5GElNbtdPKRr4ybKyHamURD06
	XMLkprtex7YARGZukyqYJztmN51UY4k=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIUfp008330;
	Wed, 17 Sep 2025 15:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IM2asB6V+oZKrPmrZPKLNrYs4TTbWhqxI2iR2+npYug=; b=
	HXJ1aP0ddUnG+e3W/K+Cm0j5dMnEczZMAf/dJBqwYw50GTMk4tYfSv1xzT1v9OpW
	YzRROZ0t7fVhrt81R13/AnJVr9BMuyfGsUhvnAtvpWV/Cv7+TIN+wZUTtrkmcAzz
	rInx5LjZ8UgyeWcHd5iX/pfgOUQEW4RGU9I7a3uTkr9Bne345sHVaCVd+XJqgjoU
	TGDNmGoPYUaYvpwBRA9I5B/VY4yqz7462d4me4aK2FKcyWJGS489dHlsCsDon1A8
	Beqoq+X6RYXf6k+/Nz7dzaS/4uGAaPC0KsCTNQ9r/KdT3QxvCBA+wXSIzoheFqwj
	/JI/+JVH+TXNhs712VKqeQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx8hfv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEnin5036777;
	Wed, 17 Sep 2025 15:24:55 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxupy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrIX4OWLSk3bX1uVCnkkJUUAS3D7ESElMg079VWstC+6EOZxTHRCDsu6aSEUculIePKNxtPP70EJ/jhkR2qFIeKgp4IzNDcn/4ildHw8P9hOceWt3qSg2NliCrl9FhCZOM+IP5TCs+x8bdDHv3haErdxGdd20JLgUT1F0hT9xf4gXWlz8eAuf//mW1f2GeSLWW97VSfA0x1r1tx7dAqcE9VQBGv+6fVlqf4C79UuGCdkJ+KpJnNRhw0q0XkRrPylmHO80HWQ7KHVfgYFHO3iwytz14/FEmHFJaqDABggKclngVS+sNGzbPzqFGlSj1WI6GbLTiHIDXPitzmy+n5aGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IM2asB6V+oZKrPmrZPKLNrYs4TTbWhqxI2iR2+npYug=;
 b=bizJCEQ1l35Rz02javh5UYafhUYlaxF9GpWYLJao0/4DNzwaQuHeSf9d+DNyMCFvG2KQEU19/7nl8JooG/Z5+wkwlqv3iThy7pWTll0wLx1o6QFTVOROh6LoJcB1iPbcKuAiZZ4kS7vi2N6imGqrUaIBhPnKNNXFmw9tz/v9hJJdnYKGmq/wkEbS4vvnyOIhpetE4PKGweP8/piUSn8St/MejRiIc+UjkoSuy9i+5qZIT3yqEaWmoHff6FkOAvgkZq130FQMR89mscfxavwFvWqfWLhEiMkSvvdoW+gaEpbYFDOf/HrdzAYTKPVGli9V4tVbLf1IDhdIMEZ81vmStg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IM2asB6V+oZKrPmrZPKLNrYs4TTbWhqxI2iR2+npYug=;
 b=CVyRzfo9RPEcmQPJbux78CmBU27GixnmdDwoKbtHeoI1xhI5JuVL/5UQZ0zKNTTDA202X3A9MsJupsoYh2bJhjTJq4aKvcYjEU85NTu/fCXNI6l1dVSsPDiScjSaUeWAGIBDdhp8x1UumrqLiy6mCc+z356tNPN2l6Zdb02b2kk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4942.namprd10.prod.outlook.com (2603:10b6:5:3ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 15:24:21 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:21 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 01/16] perf bench mem: Remove repetition around time measurement
Date: Wed, 17 Sep 2025 08:24:03 -0700
Message-Id: <20250917152418.4077386-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0235.namprd04.prod.outlook.com
 (2603:10b6:303:87::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b466bd-9057-41f8-9a62-08ddf5fe465a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JfDkg2AsUu5qERqwt6cHhiC54QCnmH5MI7GwPNvuKdIJaIHE6cYx0//m5BR4?=
 =?us-ascii?Q?Np1IZX969qgqpZjEleyYHtrPCIV0ssi4c5nMLuAHDKa8rNkz3HgJFOnbZyZs?=
 =?us-ascii?Q?BAr2ogV00FVjtnR3HVUSez3JEeDb7f/mI2BwoRyedmX0JtsJjQh8y5kLjGeF?=
 =?us-ascii?Q?ax4QN0fxTEC8o++fS5fiVIDd8oAtRcOpLkMNWZEHkg0cZ6b6d5nKLrW0TvQb?=
 =?us-ascii?Q?4+EhfLoC/KsgHM1ISEzV2Bnnph2fe31O8QFdT4w1LWKiMg6OTaVcXcyQiwF2?=
 =?us-ascii?Q?DaIwDVQnzyDN/+9LFeWFCR62eKmDw67e57rcMBbrGglFfgNteSXdvJijDeih?=
 =?us-ascii?Q?bXlmvGnPRbhyM4Ovp/d+YcaqyyiSXXv8cjelqoZebKxsDJQ8Y40CV7HndhSx?=
 =?us-ascii?Q?tk3zJm7mCqYQTKBLVtlC6N2yWDBFKTM8BdVTxvJWoXfOXZRdZ4Hz4PB9y4Oh?=
 =?us-ascii?Q?zqoQ6UF1XfS8vvIyLtYYXOo4XGBkgXtnNZKcSmH1aJr2qF+2U+qCyRWU9cKF?=
 =?us-ascii?Q?IHAgHD0bLjcZgDC5/mWOPtOjPQkGpG1gdUydT0MZfovBcla0Qc0lqG84j/Cs?=
 =?us-ascii?Q?iO0dUmaPRFeED78Cj7ZaKv5ISgjN86WTkqRdoCzUGbcZm09sDYiRzkr+3xgz?=
 =?us-ascii?Q?0ByOxz915IL+Wgf4Zz6Odpg1yvTAa699/0t70eC7bQiKGS3VHPcN4JScSG5t?=
 =?us-ascii?Q?Rg9oRjWSk8xM3uLAMp4YUu2GTJWJH3CqcL1XsyqHYPj9nw0nJPhGUpfdUc7C?=
 =?us-ascii?Q?TcEa5mnUHYv1LSIP2dNSLvufSWYlRaCMZD4dwjBlaIXkXHr76WLXwcCU5ofz?=
 =?us-ascii?Q?NOf3m22TLC4zo9UFmu6lppqXUhPv1Sh3EHV7/6XLEoPGsvKW2cbG38wyy4HM?=
 =?us-ascii?Q?62AOLVI/XMzIHvqMUPxtvOeqC6Res8pZh8955D4euuDDhiESJ2ZIXzdEpzl1?=
 =?us-ascii?Q?CPwC9u/PmgmaSrAtGCxPT3GdayyEUu11mq7k2yh8nZt+NeY/vaal9nwayx2m?=
 =?us-ascii?Q?EE2/LI75wE8zZQB514zA4ZBHQ3fh0i6yEL+GRzMtRR4Ct9xIRNTELakvBuo+?=
 =?us-ascii?Q?sNkOv+dPMYrs+j/r6XwISotgI1rV+7QezovWobs83PdG8JbDWOXQqqh8GF3S?=
 =?us-ascii?Q?bKji4TIAr+lwqfEp4Emo9yLuDu4BHWKLLverMc5KQytZGxmmDyEmh0EM1QE8?=
 =?us-ascii?Q?08LQUKqWQLnJfWAR6PgVaQ7HtqnVF0EoVONI4DdwcWl4BHZOTtpXf8Vf5l59?=
 =?us-ascii?Q?XgP/mI5obIThs+DBH0QgX/W7GbnsEYW0m6jgFLPX4Qprndi74BqfhSEVU8zT?=
 =?us-ascii?Q?g745ic5eyEVg5PaV/2QBcywqSM7gzQRTFhyuGYfMM/v0yiLlONUX7kDhwrJI?=
 =?us-ascii?Q?iQxGMBQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6A+ivMnT3w1eigj4bCvVhMf2tFTquwYt2v0qZ+zL8h8WMdrpREW0Boi2akca?=
 =?us-ascii?Q?1sG3BhuYW/0OLhWICrxZI/CSLUDcFRn+PEpca+ID3pcYRosZSnkXUx58h2gL?=
 =?us-ascii?Q?nqf4Q3EXpg3DhbsNBuHW+edW0qnypCeqVXjO5/espAK8skV9+VULVCf/oHNg?=
 =?us-ascii?Q?SUjJbGjfDGknVkpHnbp1OYW9CNYRRCrZS58X42yU15Nlx0e0LiSExLIQX97+?=
 =?us-ascii?Q?4c2/3AoxELmc9ovAlydxDg7vZTLK3E2CNrQfgbLM4Ev7gURt8wLcoeDsQ50H?=
 =?us-ascii?Q?grgeTrNCgjrUUxyWUFBrG50gibvHqrwXV0tMGU87InsG3glR7eOkA8a9IzBs?=
 =?us-ascii?Q?+/McFwDA0r6KqALoUx52XmJSaEG9MEEIMWX4rS1yj+7nxiucofqRa+TVvdCL?=
 =?us-ascii?Q?IegslUxVm4fxepYSd0hr7W+F+1NRN5G/TUTrJGJy6EJ6FC6RMCQ7CJmd5l9b?=
 =?us-ascii?Q?vBqQheX+zeXfInNCyrZ4lz6usASiCyZ6a1quRElUfhoHusgqaiTfPlIKqtcm?=
 =?us-ascii?Q?DoKzz51UcWr4aCaKhyOVcDX2YVza43bZk1BRp72BVJzAXznolg7/zzmLj56P?=
 =?us-ascii?Q?Au8zKHyVOACizxrIlXGxr/hYk/cnH0A86VlHnZYj0UkRdS+nRT8suwcDEvwK?=
 =?us-ascii?Q?4+KL9yzBC35y/IfMDO9XnID9cksOZFquL54ZpAt6HYtAdDMs+VZCT8ZRGRyN?=
 =?us-ascii?Q?w06F4UuTbQ/8l3XY6QGcRot4//uT5QyL4CzOoKWcluTmqltfK6KQRvo3MCFv?=
 =?us-ascii?Q?AayylNjvlRihpMdR0Q0Z0XchBuIPEXpsNMPYIKdoI2ZNQKBcF2fWZ5sUSioj?=
 =?us-ascii?Q?q6JtFxK8V6WIi3A5LeumVVuHL8DQ4MrF8dE8+JZub70NxJiM0doDxV+ixw2C?=
 =?us-ascii?Q?1MONEHwlpeWeCJQ6ncLareiFTcQFpvAMLgo6I+mYQFjKvbNFvjHaO68lfgBC?=
 =?us-ascii?Q?/PlreyQeceuYLtJtZZScdkRgWFLoN7Vn/82RpP8KiaDcmuZS7EcrydzFrkLF?=
 =?us-ascii?Q?ssATv0Pvbh6wA3mOem7+8841wizCOzlMCJp704kqvF0XhsI1egIfME1YQqXp?=
 =?us-ascii?Q?+Tu2XiWj+2lyD5K59fSLBIi59mn7ajTeCAtLci5XqtF7wg8DSesJrVV34S4N?=
 =?us-ascii?Q?M2ZIh/hGW78xSf/skVvhvk6tA9ULmTkMeXy+jxtemmFfA4bya6pKiObQBZP2?=
 =?us-ascii?Q?+co1WW8urwQDjhiunmPq/X355U8Aq/BNMMgzd9KhTwUjyzCK36r+2VDJZZbd?=
 =?us-ascii?Q?De//X/rBj3Mz6qNxebbM67Yz7hG1UnNmkBJBrNSGgHbU83DkCnEr2EpGvs+W?=
 =?us-ascii?Q?yFqF5XBoGFCawriYtE+azMb6OqL5uC9OVdbSdRTIGqOfsTF1InjVc48bvlkx?=
 =?us-ascii?Q?SsesS336V3CKUSIQiA1b8IHNMDO1xgE5yZfrWEUaj97CDFsJwbhjQxeJn99+?=
 =?us-ascii?Q?7kpT6ZdGGcLETSwuutmU4aWdGjDp1ybwF1ICKq6WupGLYaJOsKM+X5mDK5c9?=
 =?us-ascii?Q?rWmnnoVp+fjOkTqcDlOnn2zzvjBTn+O7lbrZWxCBnrerGCSNfS8YdGbnNeyb?=
 =?us-ascii?Q?+LgsDZs38RbcI9EMgINCEDvS259NNp+C/H8QKq5jo1QrENM6N8KIQPR5lB99?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	42fFPlJPqfruzBRQwzIwpVtPGBXPFtfsonwizAXBuARKbyseaOOydqdgdjnrphqxx8//vI5vL/NqR1s4ZfldW3aV5Lf9AaURB/5uxhHPEQ0hjJlqQf7J/9sdUhLAurYnZqosZbz5D08+LgFJCK2IWO1OT9RxnLOBo9HkxVB6fKZ0Fi+B1pYhpf3+s+/p1o4MnKhdnHaYfPonEfHAJMJTYdcTiPazb0CtHMgYK4Uo7hkjpQxfV9/7jZd9BCdx4k2e1qJHqH9cBpsW/HSRoyAHEdCEor9jMR3yZknZDFCC6xjEXlL9bJuZ3Kf/yU6aZRm1b7yw9pLAvQhoQLLZdHwzAgQ7rL3zpcleivn5sHFVrfXm21CvVgaL87OdFKWWlhI0r3lzqU1uytSEZ0Vy4+NeYnQAjAWh+qFyeypvqNeZXExL2UtfBVGeqVGfcyI/4My74sD4grBCrnlB7U/jJBH0CD+u9C1BXQDIxy0KslT5nh1Dt4YivCKvZjCgU/h4FFoQMLeaMxSKz4hmLzPUVcEai6sEHf9mLuswP6fKPkEWz6cZo25oTOa2s7VEJWLoRPIf0HnXcjyNFIIICGRYUAFCuKi3HTNRJqc1tEviEoQyc+o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b466bd-9057-41f8-9a62-08ddf5fe465a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:20.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LY3zTYouEdlBqQ6eBIzW7+5QC6O4JAK6S+aHvkeZbXi6FaIoAY5Gq9rOjLXKdgF+Gg5BhR5MQNCGZV+9pfr/Q6nKrQPQxMgLGoeWMbm2yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Authority-Analysis: v=2.4 cv=JNU7s9Kb c=1 sm=1 tr=0 ts=68cad2c8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QzB8L1Xlpqjwh72o9DYA:9
 cc=ntf awl=host:12084
X-Proofpoint-ORIG-GUID: xeXTRv2IsbKM-B2h88D7E8_-XF6FBIh4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX4D1V+X1A/YS4
 JtNcMZaHOncyEsUfix3beSvQsVxS3+cOoFl9XaU/bFCs+cq3iuBbTowT78QQF8mpGCKyLYC+7s8
 XH+56wc19Jd4zzOGTm1sCVYyEqT3cPNwDf47wHUDN+y21LJM3YKERqoQcmFpPlqu6/HOheDYEuk
 NXT4472Op75NGtJRHKBv3c6BsD2/mI0KNQ7jZPwJU5uecekH18U0H2+mxT5kPQ4a40MsKv7Tvxt
 NcdmMXoLrE8yI8LUlG8nxQsMGUBanN7FdJdOF+BDfRIHjk/ie5NPyEydVXNVQPz0PU66EB1a128
 Lh5gI7BVMctDA3e4+r4b2oDZZd+O6JxJApVJR3eZ382qNGVK315CKabE3Dh3OEvMotizaWpHRsI
 J710YqK/q4gM4PslJ97s76sNYH9TaA==
X-Proofpoint-GUID: xeXTRv2IsbKM-B2h88D7E8_-XF6FBIh4
X-Rspamd-Queue-Id: 663C08000D
X-Rspamd-Server: rspam05
X-Stat-Signature: e6y5n1tca5xoqa5uj5e3an5gwqhu31sb
X-Rspam-User: 
X-HE-Tag: 1758122713-111150
X-HE-Meta: U2FsdGVkX19kIc2UcNyY7vJ5x2wwHRTDBMiPcU4rKSx4qascxNLxVGyiBdt+Pjn57Pg7lOhbPRQgRf3QhGSHlX2BKfC7EwdpbKB6bsw+XANq17VHMNW0AhvXnKEyFWfLct9mKIw6cQiihBLgQLVw+52TekkB1QLlJaRShWynLDwB3ETzyYqV3NqRGHmlgJDba1WRT3Uuxq3awNgUJrBj0qrfLKnzPSlzOXwgLOywICDmN+GYG+npx+dCWuA9vgcSv3/wzVx0zkpMtjtIFZiluBzKpfW3MNlqJRYenMzqboNwUGXhBh2bBPpdG/a5BQu21PXmuybGvlCsocanieQEKx67UdNuBGtWceAbxyPSpR/KJTrwgX5BYpr77Y0LJvUyfvstsBQRr5xFod/DMu0yIYGi22WDppMBSmsR8qgfnMJwceCmdBEOYcDsKARW+QG7BgPZkNGsis5hSnTeRLolOUbOiGUVFHbyeoSbgPqLCFvZruppxH6p1yCjjcB0cXhgMEHyquZlm1jSjCtbH1iljQBXaIj6eZGl82Jhad6xdjc0FIhrM83J5Zp8WBjB3hbKDraCl2loKM5QFvU+tI8gIwo0e2HeS/FCnjyXinzsmyE8/wGni1XpxmO3c/EWRW+86TSF4iCsgYeyNe/N0n8h1tldKS3/QfTCdduKcPG4/KUO4nWc1FEBHS3SYzT+t1BiDCo0ywZ8kmXG1rK87TVej4j+ph0R6sriHd2HdP2jz3XOusNgQ1pZdwiKtPnwy4cChowoyZCdxHO3JT+7Q0pLl+TFcjVHK4QXjWyXn4DKo7KhoFYVxzQiZvXxRNPZsTUDHEIE62atOS/pDYoaH60equJRvNgSdKUqOf+kL9x9D0eh6poNg0wz0WZExBYpNyjbk+MnLuOLQpZp1jzZUlR/MEnJ+iA7h6NlkLB+EsDziBc2eln/bac6MCuLoyW+sXgCpiAlsVbrMZvD5RlqCAy
 4r4F2MT3
 1bZbdlCsIpq9KPxnnFnPnRfYHJBfjSJwU8ytwfmAEL01hO10t9aVgSKHwgdM12Q82AYtrYKIv5xyZN40SDCno/3dUK2mKt4GRzGQkOFRo82jTg9UdLf3133IyeAKf7RDyqsfjLjNxRl8lVmiNaIYWd5Y4dp3q6abzTYl5KBhLzYAnKGnmsHVK6G9uXbT8YF3iOB5BNyfM/43MSKLXQi+e3IFSDRxXE48g7lgaiXoUKkuII0usYCv1UQv1qr6eSkr4eTHlsjadWGQr9Sh+m1lldduvyeQILQu6yq2M5DdEPtsnHhjRcKX3jHCRBlbqTl0OtW/RJ+SjXRnpXKWAon5GAdfv3ZkT45WU2jZ3+iM1q2aJpqZJfF1PCRQBhYWTjHTq5OF/Db4Peuxa6OHUpGiWryc9fI0T6iKyY3ao5SI4wEpXf5LxAGegWdoKeQ03X+6UmNDwIW7dvlcnm4SkxSvJgJzczK2MU3WYIhTpVLzX5G/F9Jhmk3FpDMLJ+iX1AfIubZRnA/k1M0mYP1Ea64bOp01Kk/qEiL+nXumX11KUn1NkfiFofeoo5Aba/M7M5KUsKSPTMvaHYERf2PzWqH5v4tFCNWiiOearZmE7SCBQ9fRJQeMZKpuc/Hw6m9Qn33Lc6w5ZaccYfUmNFQMq4xJquo2k5KluDVLtvH6k0ykAfMglOww+WEZ4iS5SdieSxti7AdZQAD1KnL+DCKgRDI7pGiEZcGiuvfXCuhWxFrLqcywvdGazL0XZNf1/8jwYsue39XQw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have two copies of each mem benchmark: one using cycles to
measure time, the second for gettimeofday().

Unify.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c | 110 +++++++++++++------------------
 1 file changed, 46 insertions(+), 64 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 19d45c377ac1..8599ed96ee1f 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -51,6 +51,11 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+union bench_clock {
+	u64		cycles;
+	struct timeval	tv;
+};
+
 typedef void *(*memcpy_t)(void *, const void *, size_t);
 typedef void *(*memset_t)(void *, int, size_t);
 
@@ -91,6 +96,26 @@ static u64 get_cycles(void)
 	return clk;
 }
 
+static void clock_get(union bench_clock *t)
+{
+	if (use_cycles)
+		t->cycles = get_cycles();
+	else
+		BUG_ON(gettimeofday(&t->tv, NULL));
+}
+
+static union bench_clock clock_diff(union bench_clock *s, union bench_clock *e)
+{
+	union bench_clock t;
+
+	if (use_cycles)
+		t.cycles = e->cycles - s->cycles;
+	else
+		timersub(&e->tv, &s->tv, &t.tv);
+
+	return t;
+}
+
 static double timeval2double(struct timeval *ts)
 {
 	return (double)ts->tv_sec + (double)ts->tv_usec / (double)USEC_PER_SEC;
@@ -109,8 +134,7 @@ static double timeval2double(struct timeval *ts)
 
 struct bench_mem_info {
 	const struct function *functions;
-	u64 (*do_cycles)(const struct function *r, size_t size, void *src, void *dst);
-	double (*do_gettimeofday)(const struct function *r, size_t size, void *src, void *dst);
+	union bench_clock (*do_op)(const struct function *r, size_t size, void *src, void *dst);
 	const char *const *usage;
 	bool alloc_src;
 };
@@ -119,7 +143,7 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 {
 	const struct function *r = &info->functions[r_idx];
 	double result_bps = 0.0;
-	u64 result_cycles = 0;
+	union bench_clock rt = { 0 };
 	void *src = NULL, *dst = zalloc(size);
 
 	printf("# function '%s' (%s)\n", r->name, r->desc);
@@ -136,25 +160,23 @@ static void __bench_mem_function(struct bench_mem_info *info, int r_idx, size_t
 	if (bench_format == BENCH_FORMAT_DEFAULT)
 		printf("# Copying %s bytes ...\n\n", size_str);
 
-	if (use_cycles) {
-		result_cycles = info->do_cycles(r, size, src, dst);
-	} else {
-		result_bps = info->do_gettimeofday(r, size, src, dst);
-	}
+	rt = info->do_op(r, size, src, dst);
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
 		if (use_cycles) {
-			printf(" %14lf cycles/byte\n", (double)result_cycles/size_total);
+			printf(" %14lf cycles/byte\n", (double)rt.cycles/size_total);
 		} else {
+			result_bps = size_total/timeval2double(&rt.tv);
 			print_bps(result_bps);
 		}
 		break;
 
 	case BENCH_FORMAT_SIMPLE:
 		if (use_cycles) {
-			printf("%lf\n", (double)result_cycles/size_total);
+			printf("%lf\n", (double)rt.cycles/size_total);
 		} else {
+			result_bps = size_total/timeval2double(&rt.tv);
 			printf("%lf\n", result_bps);
 		}
 		break;
@@ -235,38 +257,21 @@ static void memcpy_prefault(memcpy_t fn, size_t size, void *src, void *dst)
 	fn(dst, src, size);
 }
 
-static u64 do_memcpy_cycles(const struct function *r, size_t size, void *src, void *dst)
+static union bench_clock do_memcpy(const struct function *r, size_t size,
+				   void *src, void *dst)
 {
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	union bench_clock start, end;
 	memcpy_t fn = r->fn.memcpy;
 	int i;
 
 	memcpy_prefault(fn, size, src, dst);
 
-	cycle_start = get_cycles();
+	clock_get(&start);
 	for (i = 0; i < nr_loops; ++i)
 		fn(dst, src, size);
-	cycle_end = get_cycles();
+	clock_get(&end);
 
-	return cycle_end - cycle_start;
-}
-
-static double do_memcpy_gettimeofday(const struct function *r, size_t size, void *src, void *dst)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	memcpy_t fn = r->fn.memcpy;
-	int i;
-
-	memcpy_prefault(fn, size, src, dst);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < nr_loops; ++i)
-		fn(dst, src, size);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	return (double)(((double)size * nr_loops) / timeval2double(&tv_diff));
+	return clock_diff(&start, &end);
 }
 
 struct function memcpy_functions[] = {
@@ -292,8 +297,7 @@ int bench_mem_memcpy(int argc, const char **argv)
 {
 	struct bench_mem_info info = {
 		.functions		= memcpy_functions,
-		.do_cycles		= do_memcpy_cycles,
-		.do_gettimeofday	= do_memcpy_gettimeofday,
+		.do_op			= do_memcpy,
 		.usage			= bench_mem_memcpy_usage,
 		.alloc_src              = true,
 	};
@@ -301,9 +305,10 @@ int bench_mem_memcpy(int argc, const char **argv)
 	return bench_mem_common(argc, argv, &info);
 }
 
-static u64 do_memset_cycles(const struct function *r, size_t size, void *src __maybe_unused, void *dst)
+static union bench_clock do_memset(const struct function *r, size_t size,
+				   void *src __maybe_unused, void *dst)
 {
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	union bench_clock start, end;
 	memset_t fn = r->fn.memset;
 	int i;
 
@@ -313,34 +318,12 @@ static u64 do_memset_cycles(const struct function *r, size_t size, void *src __m
 	 */
 	fn(dst, -1, size);
 
-	cycle_start = get_cycles();
+	clock_get(&start);
 	for (i = 0; i < nr_loops; ++i)
 		fn(dst, i, size);
-	cycle_end = get_cycles();
+	clock_get(&end);
 
-	return cycle_end - cycle_start;
-}
-
-static double do_memset_gettimeofday(const struct function *r, size_t size, void *src __maybe_unused, void *dst)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	memset_t fn = r->fn.memset;
-	int i;
-
-	/*
-	 * We prefault the freshly allocated memory range here,
-	 * to not measure page fault overhead:
-	 */
-	fn(dst, -1, size);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < nr_loops; ++i)
-		fn(dst, i, size);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	return (double)(((double)size * nr_loops) / timeval2double(&tv_diff));
+	return clock_diff(&start, &end);
 }
 
 static const char * const bench_mem_memset_usage[] = {
@@ -366,8 +349,7 @@ int bench_mem_memset(int argc, const char **argv)
 {
 	struct bench_mem_info info = {
 		.functions		= memset_functions,
-		.do_cycles		= do_memset_cycles,
-		.do_gettimeofday	= do_memset_gettimeofday,
+		.do_op			= do_memset,
 		.usage			= bench_mem_memset_usage,
 	};
 
-- 
2.43.5


