Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC8CCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD69E8E0002; Tue,  2 Sep 2025 04:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE516B0023; Tue,  2 Sep 2025 04:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75E88E0002; Tue,  2 Sep 2025 04:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1EE86B0022
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BCCD13B71B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:54 +0000 (UTC)
X-FDA: 83843584188.04.D4140AF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 27F281C0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b66MgYg5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DNijwETf;
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByV6StxvVOJzGMzCiUaoI+QnqBZmEM+qb8/7xN0vH7E=;
	b=BrqZcEDq0SI2T/SwzEi2QCaI0iFeXc4pCAGbfMdpKz71PhvRVigFim5GRO1DjjOrkALbNl
	NtcmA5h0RffFkAFUwdt+Z8lfiE7AL60Q6pYl32l+srsdSO9gcQMRs+hKL9YXI4nfm5mTTr
	tCiJjwZ0g8ggd1tqzjwOn0EuMWTBbtI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800531; a=rsa-sha256;
	cv=pass;
	b=F1Qgbry+i7BfWnKjMivMNTvp8RfXyAqk9g9kF7d5oUKVTx3jV6YpZd7LzAUxr9melk+NMj
	C3Waq1pHTobYfGhcZ40ZDIZAiqBjUgm5iblCFptqxsq+hw6q56C53ygUvOviEhsjy7cl9Q
	FXjmmI0hv+GiBzIKoyTAO4oehqnV8r8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b66MgYg5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DNijwETf;
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826fva1016337;
	Tue, 2 Sep 2025 08:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ByV6StxvVOJzGMzCiUaoI+QnqBZmEM+qb8/7xN0vH7E=; b=
	b66MgYg5sJxZzrYoxBbfe1aExb5DgiiNvEP8lb2qh0jeqWJMokJTd37bz0KpbONz
	DZ39bEPlVk7DkcbG6Oc9wmwc8xruQrRyYpyw4XdXg755fAF/tdsz/a9849TuJpWg
	ohXRIKDyZTx26g8mR8xV9uBczfcL+vUrJghnpYQ8Rp7EhnIMuplpN6VDh9aL9HFH
	fskYjudBnDoy1c2sw7sR3IwFWp5iczqGP0rMtDy9Nx/sYfDpbw7fGU4zguGa+RvG
	P43XxTAqlrb9YkRL2ZbrP2sEjtqDv5jQcgDDoCdKt5MTmPTL5+EvA7xiOkRekx17
	6jtVH6yf1q5YIGGFDVM11w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushvufy2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5826LAM5024869;
	Tue, 2 Sep 2025 08:08:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8j6um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XJqYhCfJEi4gLTRL7gKHNeC9UCdT0p34Vo6Pt9q2HBcQQKsjxHdWfPK42zLyLWjcGKi60w7uuZ7WUDOhoe0/hR9XKrKnvkbvaUZWiPBT6ORgwqG5Q1tN286q8CSaU5ht2yCla4QWV97c6BplPnDjtmaHYc7cqYG14bpilIXm8rbTDub9EZPZMF5X2i8BGfNWgIrfzFFOi4LCGM3sqrTjChEV8fyhAMjOwZpgzW2L6qPuCsO5wi6R5Aex9oeNoy2eIixi4EImrW99QRIGPGZADbtdNAF567Ku7fQ/ciWnfrzoouSNcJ9ERyXVPYxTuzMN7W9AR/hD6vA17lvzwbRQYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByV6StxvVOJzGMzCiUaoI+QnqBZmEM+qb8/7xN0vH7E=;
 b=Xw1QubXdcaEqA8cPRbi60/iFhkLLAhmZBkM642Yf8tZ/va2AnR12SwXxeyWvVTSbt+aEUA7yS9a5BbIdRQcdQJXOzcaPZbxX2/Z6ImuTDyPfegv7trqhnDxolRS/WZF1I8+BcWPQmiiNAo8WR9TZ6fmsEB+BYld/n1HWLvZEu/jzGM20i/jyXP43HzJUHogXDDuGGgMcHiAsnPpKfoOzOffhIGRPSPH9jFCO9RMH2QaeaiTrj8w6/xwxEwLcBrPNfU4pr/KPcdUJhhrq2K85jtfduUcEZoDGPaR0a9F+fm8jqWEOqbFnBmkL7EEi/G9SwVU0ed+KaLBryB4hWp4Uew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByV6StxvVOJzGMzCiUaoI+QnqBZmEM+qb8/7xN0vH7E=;
 b=DNijwETfYs93Ci6Fs2Yjlzvz9gwBjiX9LpLSPgf6PbAN1SQiJ3MZ3FxT6tfjRbjyZzeXepVnOYRuHnLKHu5HcRMpjm+MCM9YwG2AdVRE6oDrZgvUIY6trvwWLg3VfdE23faUnS2RPAhfZ64z7uYml0qb+q4Izk3IAHWCVlcj798=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:33 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:33 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 06/15] perf bench mem: Allow mapping of hugepages
Date: Tue,  2 Sep 2025 01:08:07 -0700
Message-Id: <20250902080816.3715913-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:303:b6::6) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 28661c31-d430-4129-e07f-08dde9f7e8cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+uqhaq9l/qWD960jyxacLdT3fygnoQu2jMwdjG9PJLvbYhq02MIAbIb0sZQp?=
 =?us-ascii?Q?nx5vyEeS8u+EPHrvT3hyXdB9aC/E/J6xc4UzpweFFLjrUDYJp2SQcIuQyECZ?=
 =?us-ascii?Q?suJfeuushrSkGDlVRvKInJeiiV4LP+K7RKIjzpqTV+4qwEwlxJZM7MJgnSN8?=
 =?us-ascii?Q?AGjxUSIX+O0un2JBs8jBEqaqtNJbL1WrB+81eNXFE20e/6d8IFW939xAMNSH?=
 =?us-ascii?Q?CzFy1mmXm59xOVaZv1Chm8E3Alu/LJXqJV7TL29lmbHTIOwnTpO0Wh5wLh6u?=
 =?us-ascii?Q?rUXzR1hUcwzvzwUsYEDIPkIXZ6zRPJY4+AnqEP9otYijSo8ibsuE975nH1V7?=
 =?us-ascii?Q?IBHnjWdjMQLIw3XwwwDuyyYmiwJpaBQuA/2OsIZikHgeZjNKqzxF8Q4ScE1d?=
 =?us-ascii?Q?X0S4+p90HkxDFZ6Ryb8nPT4sm7OsxzbJWtlte8UaRf+pnSa6TY7B2LzVrF0C?=
 =?us-ascii?Q?i75e74pH4gOZUotVjUGzrWlBdgE3MKV/7E8YoFkijfuY9zNQ8fGiT8JlAxZX?=
 =?us-ascii?Q?SFg65grtRmy0iTe/1tDmrpwMuH/chYvhHR6qJ+oewkxi1hr3EO08OSxl9ATC?=
 =?us-ascii?Q?s8bneCeugCHyz9K9UnKZ6KXJBJOhNvEN3aK4330jer2e8MNCZS73km7eTMFv?=
 =?us-ascii?Q?T3SqhS72ByRAyjnfHP91ofe9xLDkYXSuBIoRVBfeT3EoEOE652cItcE07GFz?=
 =?us-ascii?Q?hZ7VjM9yXaanQHoGEXXHhYLG3A9I0ghznjqWTDZZR+/A1RlaSxbqGmF15DBw?=
 =?us-ascii?Q?Odrgc8bAnhU1O8QhMRe8jLbwEGNGch5/E7tFfbMgrZKKKN1pufiqBemK+Mzt?=
 =?us-ascii?Q?9ZeXE8XbXnF3ChI9OJjDkupz289z1b/5JkIhO6p61ilBKpjvQGE8rJQAp9j7?=
 =?us-ascii?Q?Hz4W+toaBU4n1FUe7LeTHJL4oUrVrKNNY1V5Oc0Ya0GaatM2kToloSPFK5E/?=
 =?us-ascii?Q?3T5f2GLGoUvLph3oTYfSKJ/N7g2a2YaOeS36JQoBB2hj8yQGFZKwlyfuXLBr?=
 =?us-ascii?Q?6IPMEqmKtevE50P2JgiqwD1BAosi2fx7weJtXOoFbV6fiGm3z2E+ML3lGhUm?=
 =?us-ascii?Q?G5jZBsmJqfsgNwiZqf3BJzIPczJRoAizTjWd2go/NfU5sWQ8Q95BvTupfCB/?=
 =?us-ascii?Q?2WqZHowJXEyuRXYwEQX7dVg57oFrfQ7mFIXEB/EMPS3KyXG6S9c8gf7msh3d?=
 =?us-ascii?Q?lZ4Rj1SQgF9hSz8Qdc8lskcTn7jlYsOnDaQuF23eJYoRie4d/3myME9uTtoj?=
 =?us-ascii?Q?rNSMXeIsI4+AkN85+hCnj/xbn4U7qTHxz9bXjlbu8SoMYaXuO9SKwiH1pvgQ?=
 =?us-ascii?Q?45r+M7Z9lza9NaM3gW+3Uz+1CnZIMKNVtYs37TfYQ9YRD20ggOatw5DHy+hh?=
 =?us-ascii?Q?pNgiA2J5NbTG0P2uExo0eNOFifzToxsNxwL1wSHqO7tvQUum0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wMBmRd7HEKiERPARxXGCCZaUP3Tlq+3sOyT+FOcvGTDm/2Z0r34dj/b8Eash?=
 =?us-ascii?Q?wcJL06rdkfKTnRSZRwaXRRSCEfvGw/t2043fkYac4Om2/GUGxEli3tSoNz8t?=
 =?us-ascii?Q?lI4cqwPDQ09Vb2p909tEQSnMjgHxZ0jx1h9X+0cHL3KoVK/Dho3UXPHKCU1q?=
 =?us-ascii?Q?u9t/c+Zi7QFOLYjJbQWGRv1Bm/djDL+4sNKcgFFckCyilY0nCNXG9xgG0MWo?=
 =?us-ascii?Q?2W8z1+1hpnfPyjHCcKlmXisJbX+sS9WOdvece2WGWSwqtLlL3gDI5zqDX1Sf?=
 =?us-ascii?Q?FV2wNRLghmXphxVn6ZeYzH8aW9V2yYlj3qOpyRwIoHRRmqnEw+ZtiS+VzQWv?=
 =?us-ascii?Q?t1smMUqKmMFWtygo/4Jruoc38Nk6z2vaLQK311y9khgcM+Bi4PfTut+MQ00M?=
 =?us-ascii?Q?9xYHiA6K1ljYtKbs4TDENgkFJduLmSTliZJ2w4j9fSSzj/B57JTQPKSWW1rE?=
 =?us-ascii?Q?6w6Ys3kRsnnOXs6cR6UGcmgKGLKnChjp2dhmzRK+tU00KZIaf6zUZu48WN/b?=
 =?us-ascii?Q?t3XA/9k8Zp00iePcmf9XVq+1A+L/9Ef+ng/ej5DcMzxJCxlv9VowdEwwJlO2?=
 =?us-ascii?Q?5bt42lHFoI2f+v1qfSmJzuqzDGB39zG0bdVqKMPeLaKKlUtytANmBPxvA1oX?=
 =?us-ascii?Q?5S8bavh1FQf+KU7mXOU8/j6RRQXHIpOBEPOtCjKLkVpZzMZ287HVsb0c+tcs?=
 =?us-ascii?Q?8hK3LJgKc95I2jw5OKkyZinO+thmj4Cq10U1hZ6FygRWEMQ4Mahhftxtcqu2?=
 =?us-ascii?Q?TUj1n0jXnM8O07cZWHQlTiD896w5OWWhD8GL1pymMr+RwOGhdP+1szayZoMo?=
 =?us-ascii?Q?je72U/MNwiSTcr3kDv+kn/dBeJJjprNS1KloLB2sVOOv7oL3yS9v2TBJgkaA?=
 =?us-ascii?Q?06E0OgYDLovPZZdOUHhNuv1TJ0VhNTl3nUAy3aTWAqJzTQKdCndrO/aUC5LP?=
 =?us-ascii?Q?CmlaIF4368UiJVcXq6IpF9rC9ZG03X59ddUeKB/IE22TVJX9wIIWuG9ZdMh1?=
 =?us-ascii?Q?I7fI8l+nBnypbkx8nt+eXm9GGrI2UvahbC7sKwFoqhdXNB3tY+yESGlZYDig?=
 =?us-ascii?Q?UIpRSc+p9abBhgwAz/C3AhkbiQFhGQvOvAE6n85K6u5gcH18I5FR38iyFtHA?=
 =?us-ascii?Q?X1/am+nhJz35o6YmC0Cqa2U3nHIsnr4yu/sB+inPLQlMPF4bSYG9cpWG7pJp?=
 =?us-ascii?Q?2TQPqt0IKmjQCHVILD1uBpliusbK3ORvBV+pbtbPQYcu2laxP/cL4BQjpl/j?=
 =?us-ascii?Q?QVM4Kqd/+9umBjy/dirjmhTDh3J6hURBiNSf4DWYFm4uusWwKxO0xuO2ZJDN?=
 =?us-ascii?Q?z8ut6eRlyBvMNCagRYJ6l3tfyj4IliJ1UpPEQhOFZNSipOkCN+O1FMkkLSXh?=
 =?us-ascii?Q?/F/V4qm5T3RMQ2YDrhuMq9w/Ga5b3CrG7k0YgUCUofjyK+QQPFJyP0HdMa4Q?=
 =?us-ascii?Q?HcoenYNfIEVeGxb0Aa0TfehQVlxbjT8BmR+Ioa7RdAsarNKwr8cuBYqlfYRI?=
 =?us-ascii?Q?QQ/X0PnYB6JfVeMMJgwUcS/RO4IBGdewVZHfvQHXaFCAa3cziHuJXkhYcOFm?=
 =?us-ascii?Q?upo0czNg2paQCh1kKMA9ecqkzRJka1wv7Nuj3c/YGxkLlMJxgPrXuTRLE5B4?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7fgOkUNhGjkADSAXxWr9vmkRv4SZqO80v+8XwmT48qXQblBi8EMj1nxbualcfV0r2FJYpqSCRSoDJB+Pmn5gPAckxntKyzanxei9eq2/bcByr3iStgaVm8wyCv1GQYffi/gWbzCRAmRsDi1Tm3vZPs1sEV3EcJ4hh1TVqsYA7JvpFkBSAe+HZnDNPo0vUUM3m8pf26XS0FQPbp7Rg4DcoxVElvEbh5LsJ7fM2BZNOZxQtyVCmxkyl8znY+Xgxt3S7K11jWQX/7f1rht8xqsiJjonW+tzfIsF8OoHN+EvFXAIDY3Fyc99vAvq1o7OBtHdWDGXkoHsOhYzpDnuzdvNrPeSeowAoODi8pV0Oy9dHgnFutAwWT1Vz+AxLjFA/Fju1cfVMiw49QPLbHFtfJaIX3/kYYrLpmKXlzl4V7nP0iTHvhzs8K7LfgUBfnUx/l48NsZnMFmPdjI6bobWFDID/Nnqb9KtjbstvcTjO/Vv0miN/NwL2fXQzC0R5NALmJpag5NFAiEOeUZU78fsqnZHNldVtQoeezchTjA42WlnpBU9KVO7Eh+FZ6GrfTWA4q7MoL8raoUKso1CglLO3o2pC6c/OzvVydxobr/04sPfc+g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28661c31-d430-4129-e07f-08dde9f7e8cb
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:32.9584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n67eFrsyN0fVMzyVGfTpkDp4wsDnvopeFsx1c3Q9hu28wyoLxlcyBL5aZEav7WipU2n687wpn/QkBkjvSg0u4MLkWuOM5bhFA92+9LjPE5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX7LBTHOHXM/q4
 9IWtDNQz0QSqzxd4x/u1iAfqZJ8OO64fnaDnTJ77L6DJP5LD2JgwjbtRwysJh2Uo4A9vVwome0q
 hKxavXYmRZiCAZ/Ehk8J4OVP3QW/lLuHVoY/QdnrTcIVHVnqmlMq8wssEVNpmJXxLzCRsk6SteQ
 gGEUv60kKbvMpg6KUMXBUoLl+5NYaRUBp+ZCE+hmTqPIuzYTi9Lyc1Jgx+eEH5Fb2nSnlru2NtK
 alX8WumsW62/fYQUTZFS1oZQZcZ9vR+ZJF1ZNsDaGB9TXzfOj+yv6aPvJNjiHzh8KQIx+EiK6eG
 QKE0oi2Mtzf8P00hrS0JDKnI0FZazSMykro82o4mzMHCoibh1iIJUr2GjNMAUv3HRv06Ps/oNNt
 yfhbOvSY
X-Authority-Analysis: v=2.4 cv=fZaty1QF c=1 sm=1 tr=0 ts=68b6a605 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=lQCSvQGvPXAejg8cu_YA:9
X-Proofpoint-ORIG-GUID: hG7gbxNFpXiEAp0izea2ypd6s9gyd10x
X-Proofpoint-GUID: hG7gbxNFpXiEAp0izea2ypd6s9gyd10x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27F281C0003
X-Stat-Signature: 64879gz9j7wj6ufd98h5m1pe7gnnfppf
X-HE-Tag: 1756800530-309163
X-HE-Meta: U2FsdGVkX19ReIgA7LXIr2nX++KvOKmDsrmIUj13haDlL3VpMxxDPExIaZ6MyQUNT6GJCQljKnsbj6MxXTxAByilzqYMI32PEaDtS8c0ZTzq9jrPT7FjKjGSpRXDB2spbCGVullDYnQJJV9He3zo+IV+h6F8k21Ow6t6bfkhelOyu1Y2Js3G46fJpjHJafIuSQpSys8zP8sDs8GPaiXdR5bIqlw6oWEB1JUH6KICGDwFcrqFbVH0dDbkm0cTYAOCc273fy+/xUSNLVHFvGvvZ+Fh6T69+cqGXNg+zlurJl7g2aY1idF9k/AxN3+JmtdQhL4WWJARKzocuPha0IGqrZF5U45i1Vla12yX+gE/yugSFaKYaZQf0doGFy4VxY6HVI+mmPx6SZlg9p/A3GEXsoTsshnMTED7A68Y6uAn9WbBVq/AuhQFE1utioF+JaxLoK12EML1IITWHh06SnEQoejxNt7Y71ZQ7ZrsziH+T1AUCbzS88hGBpQI5IudsFdWLtGCoqUUc2OmA/zmdBkD82lUGuAyp51UNkHWV/brgFAeFd7ontGLbBpHmj3nXT2opAW2NwWw4ikwHcMCFhsteWBlnNwIVAuBY8JvjdGM7r4iMgJZy6250PtCRJKR4h3rZjXbYSbCTapwixN5pn5cGB6z18vZThb/p38acRMKLT7IST1dIM/mf81mZLqg60xpnxoCNEE3S41dpWyFTISOuFPhZC0niDG9a7tJH6Mi7zPD9wWfCdJ+ydeLbEbD5V3cWnUSBZit3NMHyITAcRJkxy4uYrMOuaeXVV1ckew71RkLdH0Kg66acXAtjtJzP1wBp4MYLDpnrvCFeCTiYBOSAvsg4d7vREsXmigQKg2wfGEW9cEGyGS78i0JNf3pYuW46z7WIudJtjoDmwmMftS5WQSTiE4wU5+L5jRklHsd99jIneAYsE+UOzGWoVAWS9gvQC0wFKcMJ7JpjIxqPdh
 +JKpac7H
 wi+AWQQT9RF6Vta8bnbto6eIvlyHndxgtEcyYPe+fCatYKCOZGO3iPy3oplPUCLySYCu9eJ18TiidshkU4WkTDAsxHe7NWhksND/fCSLPRMfZkAhBd4aU++bouiVbikzLwEpKVOTgadclt6m65lyucS9qCQxJ1tz9o05fqh8qRNDpN66DvHSwVQHR2GNGvpTux7PyOGJdN7J9E9vDURyD3GFcpDCPV3hxy8KECHxvFmO/1G0cNkztN+Lybsd1mfe9/D+IvcJqTr7wS0JFP+8+hUbm/akJ2TSyRC49hZsfJRCfWeWBe8HHvfTVgeIhwP4NsWIjZLIV21L1e7is0ARqTkGosKbUm/cFTJQVRTWUEBkxkHaZq6WK6WXMzOQmoe8u5XUoYnON/jwogrFMGqs7l0Ym55kYyzsismvuqSMchgLb2E/iEMuEd2EqKSVvYeQyeYYlJ9T5TlQCjzfAsgKl5+G8s7a0cNmlNk2imCPl/6uZuasfgGs3mdBJRAK6KXHvvF1pJnQw17dHy1L18maKd6nEpH5mQ1oe6hNLKqYPKq0WtN0PoHk5nQ7/rG9Edv3ZENlNCWB8bqiaLq9ZmqnAQRM0X+gDRdAp1rJmhMjwyrYkbVteIjQsLGBOKWUqP7xRLq4egaeqJj8EV6DNBQzxIryKEKRYYgukZQGlPDiotil1CXEHIhbYQocENjjahA5cJeOV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page sizes that can be selected: 4KB, 2MB, 1GB.

Both the reservation and node from which hugepages are allocated
from are expected to be addressed by the user.

An example of page-size selection:

  $ perf bench mem memset -s 4gb -p 2mb
  # Running 'mem/memset' benchmark:
  # function 'default' (Default memset() provided by glibc)
  # Copying 4gb bytes ...

        14.919194 GB/sec
  # function 'x86-64-unrolled' (unrolled memset() in arch/x86/lib/memset_64.S)
  # Copying 4gb bytes ...

        11.514503 GB/sec
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4gb bytes ...

          12.600568 GB/sec

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/Documentation/perf-bench.txt | 14 +++++++++--
 tools/perf/bench/mem-functions.c        | 33 ++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 8331bd28b10e..04cdc31a0b0b 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -177,11 +177,16 @@ Suite for evaluating performance of simple memory copy in various ways.
 
 Options of *memcpy*
 ^^^^^^^^^^^^^^^^^^^
--l::
+-s::
 --size::
 Specify size of memory to copy (default: 1MB).
 Available units are B, KB, MB, GB and TB (case insensitive).
 
+-p::
+--page::
+Specify page-size for mapping memory buffers (default: 4KB).
+Available values are 4KB, 2MB, 1GB (case insensitive).
+
 -f::
 --function::
 Specify function to copy (default: default).
@@ -201,11 +206,16 @@ Suite for evaluating performance of simple memory set in various ways.
 
 Options of *memset*
 ^^^^^^^^^^^^^^^^^^^
--l::
+-s::
 --size::
 Specify size of memory to set (default: 1MB).
 Available units are B, KB, MB, GB and TB (case insensitive).
 
+-p::
+--page::
+Specify page-size for mapping memory buffers (default: 4KB).
+Available values are 4KB, 2MB, 1GB (case insensitive).
+
 -f::
 --function::
 Specify function to set (default: default).
diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index e97962dd8f81..6aa1f02553ba 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -25,11 +25,17 @@
 #include <sys/mman.h>
 #include <errno.h>
 #include <linux/time64.h>
+#include <linux/log2.h>
 
 #define K 1024
 
+#define PAGE_SHIFT_4KB		12
+#define PAGE_SHIFT_2MB		21
+#define PAGE_SHIFT_1GB		30
+
 static const char	*size_str	= "1MB";
 static const char	*function_str	= "all";
+static const char	*page_size_str	= "4KB";
 static unsigned int	nr_loops	= 1;
 static bool		use_cycles;
 static int		cycles_fd;
@@ -39,6 +45,10 @@ static const struct option options[] = {
 		    "Specify the size of the memory buffers. "
 		    "Available units: B, KB, MB, GB and TB (case insensitive)"),
 
+	OPT_STRING('p', "page", &page_size_str, "4KB",
+		    "Specify page-size for mapping memory buffers. "
+		    "Available sizes: 4KB, 2MB, 1GB (case insensitive)"),
+
 	OPT_STRING('f', "function", &function_str, "all",
 		    "Specify the function to run, \"all\" runs all available functions, \"help\" lists them"),
 
@@ -60,6 +70,7 @@ struct bench_params {
 	size_t		size;
 	size_t		size_total;
 	unsigned int	nr_loops;
+	unsigned int	page_shift;
 };
 
 struct bench_mem_info {
@@ -202,7 +213,8 @@ static void __bench_mem_function(struct bench_mem_info *info, struct bench_param
 	if (r->fn.fini) r->fn.fini(info, p, &src, &dst);
 	return;
 out_init_failed:
-	printf("# Memory allocation failed - maybe size (%s) is too large?\n", size_str);
+	printf("# Memory allocation failed - maybe size (%s) %s?\n", size_str,
+			p->page_shift != PAGE_SHIFT_4KB ? "has insufficient hugepages" : "is too large");
 	goto out_free;
 }
 
@@ -210,6 +222,7 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 {
 	int i;
 	struct bench_params p = { 0 };
+	unsigned int page_size;
 
 	argc = parse_options(argc, argv, options, info->usage, 0);
 
@@ -230,6 +243,15 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 	}
 	p.size_total = p.size * p.nr_loops;
 
+	page_size = (unsigned int)perf_atoll((char *)page_size_str);
+	if (page_size != (1 << PAGE_SHIFT_4KB) &&
+	    page_size != (1 << PAGE_SHIFT_2MB) &&
+	    page_size != (1 << PAGE_SHIFT_1GB)) {
+		fprintf(stderr, "Invalid page-size:%s\n", page_size_str);
+		return 1;
+	}
+	p.page_shift = ilog2(page_size);
+
 	if (!strncmp(function_str, "all", 3)) {
 		for (i = 0; info->functions[i].name; i++)
 			__bench_mem_function(info, &p, i);
@@ -286,11 +308,14 @@ static int do_memcpy(const struct function *r, struct bench_params *p,
 	return 0;
 }
 
-static void *bench_mmap(size_t size, bool populate)
+static void *bench_mmap(size_t size, bool populate, unsigned int page_shift)
 {
 	void *p;
 	int extra = populate ? MAP_POPULATE : 0;
 
+	if (page_shift != PAGE_SHIFT_4KB)
+		extra |= MAP_HUGETLB | (page_shift << MAP_HUGE_SHIFT);
+
 	p = mmap(NULL, size, PROT_READ|PROT_WRITE,
 		 extra | MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
 
@@ -308,11 +333,11 @@ static bool mem_alloc(struct bench_mem_info *info, struct bench_params *p,
 {
 	bool failed;
 
-	*dst = bench_mmap(p->size, true);
+	*dst = bench_mmap(p->size, true, p->page_shift);
 	failed = *dst == NULL;
 
 	if (info->alloc_src) {
-		*src = bench_mmap(p->size, true);
+		*src = bench_mmap(p->size, true, p->page_shift);
 		failed = failed || *src == NULL;
 	}
 
-- 
2.31.1


