Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75612CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0D78E001A; Tue,  2 Sep 2025 04:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC87A8E0015; Tue,  2 Sep 2025 04:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69128E001A; Tue,  2 Sep 2025 04:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2ECF8E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:16:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E2848655E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:50 +0000 (UTC)
X-FDA: 83843584020.18.A4183A1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF86DA0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jKYxvU0m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y8iD+LBg;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhBiCJakGhwo1RnNxths/dC+QGi3BIEpQtfuaUz4igs=;
	b=14x0IWYEt6FhBB9U8c4e6BgDPb/T4bEDMtY5OEULg05yRwAhRT47LQvvGIN9kpIVjEW5we
	eFedLyPowajJvLzB9cJmRiQmmXnUVGqZp912B/p/vPmwo2JHw0AuscwfK61cmQQRw1TOUc
	PZ9mR/ra2yumuJOanxv0n2kpd+eGs+k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jKYxvU0m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y8iD+LBg;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800526; a=rsa-sha256;
	cv=pass;
	b=yCCqIdxwTS3ephn7ngMcMTuQ5i3wbWDqEuYSGbqbNft6mX6wdxYnh/W0/WU3WTUQWqRlE4
	pAUYoBcUTdTIarU3N5eJhJ/3n0gecNVzIRZiu0nyhrew2JvWsBjnTSx4WefupyrN6JYjPt
	n3IVmDp78iplb4DN+h6eLHWi5LA1Yws=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826ffjY016190;
	Tue, 2 Sep 2025 08:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FhBiCJakGhwo1RnNxths/dC+QGi3BIEpQtfuaUz4igs=; b=
	jKYxvU0mXbiyjfeLxlAKghykDu15YNqPUoLAopvWn3kmiIeRVob7pz7GN9W6kRFc
	72DaCGgV25wErJKShTQFhSAqhe8g7JUxDbcW4QZhZWwA7w35/crWjrOtbRAUxpqR
	aJDYFGQwXl+PMQllJcWbeKhig4n6GFPzJIOlmt6kU3seVMxAHqjGzShfJd2fKYjg
	sVZyzbFfEf5l3ZcBAnSVeOPG6eQUfXI0Brfjx0Qb6B8o0DBU7qctnO54Vd7FyEO/
	8FYsqIL/KdwsR8FFvQV0K2vJMrAGQ9EjHlUxKIiXC04Eq8yTBWWwcP3Q99dRuS85
	S29nLghgfkQzeqBVZTGI6Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushvufxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5827pDKC028734;
	Tue, 2 Sep 2025 08:08:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8uvv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2r+hR4K+TdA2YeMHkDi5r6IA+fpUaPPzCVd1ZMD8lmQyQID0XgmXB5S1TjkJaFJsEae34L2/XucNY3n3gz8Phm4gSUmPg5tOTxnVJOlwlMOBD0W45ojAgcp2pxMec+Cmywav24xGyJceD83ZZcf/aOIsptH6ZWUrrzH7oILyg7Uj/gBzDRgJad5TA78SnH+h6ZZzZGKbfifNHFmWRD1fOeTCUpkVI3Ki7Y7Sq58t411YHzJ16roahawenBMN+XR278PV0WGhtt/Ht+ScDDX47zmg4Z1MD0IBhzCJ0YhIfbkA7FqJDAzL8z/W9GfSexW/Eit90BDcQJeG86yrbFsmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhBiCJakGhwo1RnNxths/dC+QGi3BIEpQtfuaUz4igs=;
 b=GSWKkK7kov5VfnHQiABm71xR4Uu0RNSNwPBpzK5cDsgtProwSd2hEa6d7OzOClw6GiviwQDf8IbIHenYAtRXZlYYM5v/tF5M8rZQsdKnTIdAjPT2gZirDFQKf4LdqD/l48sRYhg7cieayZ91XzmbNgDbjhXo5VX8cefG9dsKWZqdPWvXhZiKNybQ9Uqq1bS9q+YPBzYw0X8oY0nzdeQ5T3DSYk6y6hAb8hc8oE44POqKhRnJbehRwlG4Zw/4XqfsECnsOFQrB23FfgW6cEIA2Rvjk6Dm9OQ1sBy/1GjGWjYXo4CSITRS6OeZpvi0l7CpcefqaBYMXc5cRAalU7PoXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhBiCJakGhwo1RnNxths/dC+QGi3BIEpQtfuaUz4igs=;
 b=Y8iD+LBgivBaSVU6Xg/8RRINZWRHUWketrsM/2fXIem5Da9vnnx3BxUF7+ncHtNPbD47lGWqK8+qmZWMj0w6iRJ90274aA6hWuErgNJ1pBJYRAzj/GW78SWLZdjxVmxToZSHgC22nqrBRzoNmbDkB+H0tVdgjoyUCuaZN0ygJxw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:28 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:28 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 05/15] perf bench mem: Switch from zalloc() to mmap()
Date: Tue,  2 Sep 2025 01:08:06 -0700
Message-Id: <20250902080816.3715913-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0208.namprd04.prod.outlook.com
 (2603:10b6:303:86::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b4d3ad6-3367-4ba5-6d00-08dde9f7e60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZJxUEEaHDucNpnN3ZYTWi3/v7EntlT4FhlnijfIPQRP2uB0bdEJmHvuzvrIr?=
 =?us-ascii?Q?RXqPAmJuA1fo31TxC2akPe3nHnTRDjwiCzKymy7UcPyJmExXbrre0XrNopP1?=
 =?us-ascii?Q?WgD77gV9pXzbXHK7spHk+ijc6gM+Fly3+j1atlzJAJ7MYCUzbUWndSJLQrUS?=
 =?us-ascii?Q?VMENJ058GdhJvcGP9SB7tUdsqvg9hWjfr7ZKYq9jYkdMnAdg5QJSikIvvlSl?=
 =?us-ascii?Q?Jhr2NiiM7Va8bzT5fpWolK9p6+U4Y9xHyG72KSj/A3SoKHp3SnZOCnPH7Lfo?=
 =?us-ascii?Q?Set7Vh/fR8A8iEtOsPqGdySCX2rPXTus9pY7W0KCqAA17RqvHU+ARzJbPbya?=
 =?us-ascii?Q?0Gx1za/PKhXAHSOqBcFU0jiDHx9n9/QG6GmdFl2U6JA6Okx6+CMCBlrVpie4?=
 =?us-ascii?Q?hafdVuVXRIdTaAvv0cCktjHxHYX5Rcia8wLi3/f9/+wSvIrJ3KYwE6NXx7K7?=
 =?us-ascii?Q?EU/rEZyPsiEnzw3Bm/PPV2o8ZKRPqgQB+iP6GMYky9AR8nhC1kZqOOgBOzuC?=
 =?us-ascii?Q?LiM47RNoofWxtyqc2jImq35snMYu8RKn+acf+AGk6WdAq2Zt5J0EPb4UR3Qy?=
 =?us-ascii?Q?6qbOTi7gbYFZyA7jMQdoi1I8qvHl3jywqA4iDrWX34ANxGgiHlm+pPjtuxoA?=
 =?us-ascii?Q?onCuVxjuYh0OgK6qUXivsBivG4JOXZ9p4Lr8EnuwFJoeKQsa2j3LJHWKLDdt?=
 =?us-ascii?Q?5hVA2WZ9aSXyXEDgI4OxqahLmLKou8ngvAJmnmHWwHmLw0q/pJX60/jcok/F?=
 =?us-ascii?Q?NoWN294nuS/WvetuGWnqFPGAGf5ahZSY6t+pi9Nl9Szs34CKXhAt1t6jTnSk?=
 =?us-ascii?Q?QAb/uMPV1gL3FHfHfl05YTXukyU45SUdIO2m3ugLd/p1Ke07us2XR2RI6zcQ?=
 =?us-ascii?Q?PEn2Ru4cxYsSd7S7v+NdCh+MIfeh1Bxsvr7/O1HKNvuo71rk1NOWd0/ngXDj?=
 =?us-ascii?Q?44/PKM6MkvBMQ1iu6Br4O2JqBKQEZENLdvnMk3fChehp6Z3DXYJt8TltDavi?=
 =?us-ascii?Q?OXSNAQeGIPCezVZlNbU9kinzEPFLGnL0Qv12SaIPySqbG+Ty+1ovTjkVkOQX?=
 =?us-ascii?Q?BEykAKVeFhN/XN/HSamwtbnOvHGDgJ17Tvs6VuCsVaCTk2m/Y0uB/cOiWdR1?=
 =?us-ascii?Q?uemPg3huUe416mI11ls7AXEgegp8oGou+73m4IwWEygoBuVCatNgvBdGd7Q5?=
 =?us-ascii?Q?GN1ad9nPHzZuiqprBMPAiPfzNHfr8aGs+dSRujrO/L8J4pWslZgBcfU4IISI?=
 =?us-ascii?Q?Y44jBZGDsmXFtQAp/MPIWP+SGGbh7faZKs47s540rKC2WmlLUac3xcr4oqor?=
 =?us-ascii?Q?SkkeWctD9auwJqaulb97fWuqTYNRu3hYrb1ln5jruh4F4gjTUYZLEv6uk5pT?=
 =?us-ascii?Q?4YV32xdeydxYu2Sf3m+D88moY7kRe21X5k1U+pfqDToSTZQJu6DYztAyopuQ?=
 =?us-ascii?Q?bJfH++zS7F8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gUWmwiSbZ9owa9fFuwJW3LOqnV1YTHapUy5WTCvnJ7WTo7xIphN182GoIdAn?=
 =?us-ascii?Q?ZwTq9h7h4ABl+xyEVLfNcDwBAKo5WK+orVqcgZcN+vFSdOHemLoou8KHSB6l?=
 =?us-ascii?Q?fF/wIhpR29yf+Po44JeBZm0JfJXZbz5AN/CGBPTFgbq1PD2e37+d7g1UfFBw?=
 =?us-ascii?Q?uf7rNC8zRO7V9B2aZ9jSCvLz0dXaLG/34MlIruFiktrwPTpNov+0v+fvdM2J?=
 =?us-ascii?Q?s2LkIg4TxxAOEW9KP5mheUiYXAu8hI6yZliehhAKyPGs+70B+EcNQ4oRWp8u?=
 =?us-ascii?Q?Kwj07NaMEgxfecbxJLGGG4OuKR9Lxpe7859zeC3KGUg6jiuPBJcJv6d7Lr2F?=
 =?us-ascii?Q?6D+7tNQLu8WgarFDJHFTDv1IlQ2+/Eh7f32TzJKe212XdtsguIrgvMx4vVIY?=
 =?us-ascii?Q?/n7+hJTuPF7uz1fNIUkexndK5pv6EUBRfFJKz57XOkoAsGvYhHlKCLRqPZs3?=
 =?us-ascii?Q?8XbJ3yy/WKpM5WW40gqx3YQNVdO8VqRwjuvFiQo043KzXG2lXmZ+kNRlQWvl?=
 =?us-ascii?Q?c5QYLQiSlny38uszGT9QHNZ08ZrjxKG4kRNfwggsuSHyTh1xVSImxAU0mMjc?=
 =?us-ascii?Q?3xcj/H450yKAyT6hLiZGHbwDGdrz6ZP/RHGUvGpgIWo6JKgbwws3YLclQQ8d?=
 =?us-ascii?Q?gSMsUOGEOLU+l6AbsYlyDsYWpRI5M4iO0HmwNNoWfr6os9R3/eL+MHVieDOu?=
 =?us-ascii?Q?GYjxf1ldAyNbnW9mc6DjfO6irZ9zL/3QT03SKMJJIv4CIVRwE/SnFAwzrZri?=
 =?us-ascii?Q?LAR0JoWP53RBLSnrb3kCgxu72SyNkmmDKd7WBKOVU8A0Ko1zv4LRmNDq1MfD?=
 =?us-ascii?Q?Qcf3pIRk64cXzg/PkXGK+PdtUVuvV/PvWRHD0fABhwlLPL2ER+IP0Y4zgnlR?=
 =?us-ascii?Q?kHqc0tHtOtndb0S5GUqw+yLqSrubKDZCxoZY1eqjwrfzGeKqjmQP2U9mE0Sa?=
 =?us-ascii?Q?YCi4yoqtsmSxKPe+x5OTcFLw9a+alhiugFw/yg8Sp7nxCLRce09cTnktjX3G?=
 =?us-ascii?Q?YlVNzXuE06eC8TeMdpEwR8HPk3VtbRz8DNgkUMtNiUkEI/BOpoAPDutpSG5Q?=
 =?us-ascii?Q?rCAc2aK+mDVNJkcY8G5rPe1kC7WZy/x8HFW/5MQjcXGPwAZT0X8xC28R3F7W?=
 =?us-ascii?Q?tRsDq6Rrh8sCbxW+EcOyAayN82A2A+po6eq7pbUWYPmp9NH58icKfkDHhDx4?=
 =?us-ascii?Q?o4md+/Fw2jbc6Ae0eXBhNrypk/3x2d5Y2tf7+VM3caG8L7fiyUwfb6G5Vl8M?=
 =?us-ascii?Q?dL4X8eTW+q4DKTUqESmtTcLFc5dWnxOm/u+OoU1QkoFq6zKf8Ao7GwOc5M8I?=
 =?us-ascii?Q?Ss7R7blBuzc4DG00rhpzxXLhsWGZjBRpSG1jUgdPvR4qDS/uDd1Uq672Mfd1?=
 =?us-ascii?Q?AYDK5W5Tq3Kb3SL1DcfoHEmyF13HTYPF2dv5edOPOS8/A1zrtgP9vbR+I4e3?=
 =?us-ascii?Q?4yoLrUGy2wjerZflkR7xcYPDubZvSv+ACkpsrbJOP/fFmx8vTi47zClN+lmy?=
 =?us-ascii?Q?Lk3JNe8rFkrLffoP7sc4LhrO3UsJ3JmDSo8IX6LqRinoApXf2GsmuKrdiE5t?=
 =?us-ascii?Q?PnPSKDDBNQTrtJUlfVhiSyqzyiyObuk9Aj7IMGni357QhKSxfu+Q3G+/5H1V?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uce4hZNU/9SchMvYjbIoMfca6vib2Rvo4Rfv7cDkBynLe/8lFR+bhMFhwKGlmL6bFl2W6nDbbyl1rf4hjXDL6c4HVn9WD+dTeKXvz0yghSNIIiozoVQCgTAEi78cH9ks0UNcQ4bR7isER/S1yRcoYDmIRInt/aNsh2F7O66aDSXJzce5ytDQgxdsnGNR/C74x20GF754xtk4+5gzRznvAJPjHPy/izOj3C6Silfg12Nnm/MDRKuxgGvU5FB74bwOtb6uwhSmz324FuT6iRFIGI60bgQRuABaJLVdj0ANrdEYyHcxlOLo0AAvFxhhuwsd4PJIkmT5SzeYJ61jJ8POeirmb2vQSk2AnL+glccLa7VlY52/HsYOwDdMeWEVTFMfXo0I+J7pcGuh32rzwLE7YMox2kDNE+i+NzYSIwcNWcrda6Gd00r7XymlmDr7R2oXSgAEz6kKI5p/N/sLVf7/P3a776e3x1hFYGLjVDm0Kmp0u40zSpj1udLiBmXFrURGU8LBdwCb/I5WdCCHutc0XUT2nt3Ydn899nup70OCFmBPwcRXJqkqoPCc+c4Px9l2JBGjwlYAsLxNecruZ+8GrMH+FNne04f7o/jtMF80IJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4d3ad6-3367-4ba5-6d00-08dde9f7e60a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:28.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8p3leL7hfhSR+rvfc0AsZrZyq7Te6FCMG3IFURyqfkV8o6Ob5EPGts/VlLPqZc+QzEWPav1nDZm7HEb1rYx5emShYuBPFK0+0TBmc+iC1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfXzonIpinUIMrJ
 qkVHanUdLYWeocN1FrDEQGAQhBUNE44L/CSnCnMUNOLr/8tFhWNN+GZRIV4+GgBuc8rJL7Meyhp
 uFJ1XIAJfUoxvJJHv2hszg4BL6lHt+mnwjO8byLmU8cXORaoidJftOh/0/Sb7S/F/DsFTb1Pjs5
 79+PgJ98ob5nh9ty6VisVgtLql51/zsI5LBK2q3LjRVwZpX/3inEcjHnXVFbCysWyGmBG4JkYpH
 LO6GprvGzGwGF+cUMTlfuHRNOohf4ezmRoXpBV+XfcjBi3S6NlIyiEv0gHH6IL8n2hYqCri8iBP
 Jt7aDWdudoAQGSlVMyMpiFZNzNZuJVpYFsu/41MYg4U1WyVIdif1DcHUMoT238CvjQx5YypwuqH
 OGJmIFnf1p1YfBDsu/n6T551Jv0Ufw==
X-Authority-Analysis: v=2.4 cv=fZaty1QF c=1 sm=1 tr=0 ts=68b6a600 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=X8XlAeXZIpgir3S8H8YA:9
 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: RhRhM3wO3-rI2v-4iCVvBqWSfhg7ouz-
X-Proofpoint-GUID: RhRhM3wO3-rI2v-4iCVvBqWSfhg7ouz-
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF86DA0008
X-Stat-Signature: cyrx1aeuunuckth3ep6s4oxppmcioyz1
X-Rspam-User: 
X-HE-Tag: 1756800526-644148
X-HE-Meta: U2FsdGVkX19HXyQ5rg01NJ62moyKe6AifXutyvOh0w7xzrj3bdS2GVJluUMUcPk513/zGqx0DnRSEE3KZ4K+lSLHKWEZ+f+g1MHhQDIok/DqmCVM4k/kxj+L6c4Y0S4qwRd7+9/wZvvl2RSdJFrpO0OAmrUbXWknRKqUqTmfRW8NZcnpwJZZfIyG32O2OdRhLWLKiocMjbye3tNtCUqAbxaX/FdHOjQorAUqnd4NkGIPh4G2Cdhz2H6d0dLulKiWDj6lsuxceK2hlnr1AwcSQCWSkqkclBmsN4MPG7UZ+0olblPvDoOemJpx8Zbg7msnAFNw+wyV+BNUU3pgVq89YLK45zaBNXcpuo4HL12qDzDiX4+LyQvV3H8A14ne31JX6A4P5Gdw9TpivkxD8BRMNeVE4YNDwi5Nh5D0xHyi+Bb6L+/ZscfOjHaImsqyC20lO15IfWSO1C0BnjDCYLwGK7pzeNU6A3fSmgqdTF3oRh2eCBQQsBHdR17XpbsHtQkFnQY9s7Lg15yp+ApfqjuOXlRm0Vs0zvg2zpPMErlp0r7WjOUy3Nj4NKKXZHCAl6vVaBv4ClNBvVuFSz91aSECgTnZnq28Gmu4lM7Gl7FP7ObYOwHhusgbm1u8d1BkWsSWG++gyjQT8wUriB/QWlBmZIchBR0gv8OfvZWsAU2Mn6dtNpqb6/HaFVZP1ERwVnmGl1kIMZDqdX/d91nUp+6onkUXkqGYvao5Fz+02rzG+clMZPyMJMU8MtUezzRhLJaCfwzkhENLeRksugLO1UBsqXGja/5PbN3bwMH0xko03g2pfV8TOG2c3x6pf+tK8X+jmhPO6MJBdAGw1UFQNXV1ilOx8cNSoU9r+B/A6rwfZ8KYZPmTED4V2NSSsaKYeM3hsj17xhCljMzr9x7NjB+gFWsfwpD3DeIqRivEvE6ELARrS4k2UIoqzPfe0pZMxd8TQaw0JCFJFsrIUi22Xua
 woYRMiGT
 akvqaIgwlYf3qXqfv5FBud9COjXjWCkHZwjYeoRP98uBCHqS5km0i5buvDhI8oNMhoY7IGSjfyzJtedKlqe1oA64/wNvbXQ5eTWd+EEnO+QBiIJsRI0HTHVOaD1PjxZ/HQDuX6faq4ZYG/fzZ8iv1JCa4vk+yuBQodHZiUylQqVJeCP8vrJNZcB3FJgFc6vwOyDCCXXPafoOurPgHgscnDMEJZsUNdtZnfpB7i0T899/F2//0+vCnQdG12XaqcLeSPeezpH1nKmlGYiG30QmQmHOkE/ncjejwpWzhTqA0vzO8aLCtKy1rFXCYmcK5rLyK36ggbMdwB/OoadWpzb2bCQo+kL7C+bGhNgpHrLH0pHzLlNZ14Ruz22Sn+gpGb6d3feBVeUyfdX/PqZ8MxDpjCtLPR9V/5lxlTdvOUbWYvJFD9hBlguiFFWz16VCJJ2wxFt5N7k/ouF4V0W5DpPp+5Y0xFnbzC1LtZR43RJRAvr7EEuYQEKFS1RCL2oPl5jYXVJ9+dFrETalqO36G+HKbYkLA3DSX4UIVbvryI8eMsUb5g+m0Z7pYXFIDmMQZpe/pV6Wz78BZGyfcZPnB8JGZdWuKuCdxTzWS5fFNBRD++Jkk2AmYHjBy7CklAezY+iJk2SVw168jrY0Mpwo4EJ7s33vxr+Uv2VMvP8G39GHgDYYu0hDN8bUJOjKkJVfBSzL9o8lfLL7x/7XDxBytxlJ7K/JO5gFDcPlDyh1M2tmMunwLP/BiYgPOmAWabfOK76qR9BshuqQeXslsl9UGpaoC5R0P8mJPHmGZUgiR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using mmap() ensures that the buffer is always aligned at a fixed
boundary. Switch to that to remove one source of variability.

Since we always want to read/write from the allocated buffers map
with pagetables pre-populated.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 60ea20277507..e97962dd8f81 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -22,9 +22,9 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/time.h>
+#include <sys/mman.h>
 #include <errno.h>
 #include <linux/time64.h>
-#include <linux/zalloc.h>
 
 #define K 1024
 
@@ -286,16 +286,33 @@ static int do_memcpy(const struct function *r, struct bench_params *p,
 	return 0;
 }
 
+static void *bench_mmap(size_t size, bool populate)
+{
+	void *p;
+	int extra = populate ? MAP_POPULATE : 0;
+
+	p = mmap(NULL, size, PROT_READ|PROT_WRITE,
+		 extra | MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
+
+	return p == MAP_FAILED ? NULL : p;
+}
+
+static void bench_munmap(void *p, size_t size)
+{
+	if (p)
+		munmap(p, size);
+}
+
 static bool mem_alloc(struct bench_mem_info *info, struct bench_params *p,
 		      void **src, void **dst)
 {
 	bool failed;
 
-	*dst = zalloc(p->size);
+	*dst = bench_mmap(p->size, true);
 	failed = *dst == NULL;
 
 	if (info->alloc_src) {
-		*src = zalloc(p->size);
+		*src = bench_mmap(p->size, true);
 		failed = failed || *src == NULL;
 	}
 
@@ -306,8 +323,8 @@ static void mem_free(struct bench_mem_info *info __maybe_unused,
 		     struct bench_params *p __maybe_unused,
 		     void **src, void **dst)
 {
-	free(*dst);
-	free(*src);
+	bench_munmap(*dst, p->size);
+	bench_munmap(*src, p->size);
 
 	*dst = *src = NULL;
 }
-- 
2.31.1


