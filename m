Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726A4E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100BD6B00BF; Fri, 30 Jan 2026 16:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043CB6B00BE; Fri, 30 Jan 2026 16:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80C96B00BD; Fri, 30 Jan 2026 16:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADF8C6B00BA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7ABDA140527
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:15 +0000 (UTC)
X-FDA: 84389850510.30.13870A5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1336940017
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=prgOe0az;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k1EJFnM2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806872; a=rsa-sha256;
	cv=pass;
	b=AZqrzS88v0JCFg5rTNt8Mbaa6WfReDRsVqd73FPQrwKOkcg54+So5KeUXgh4RCslv2DCWD
	sQnss5vkNiWfhul8QbsZSHzCc+TKmnGF1PPrDE3FFOY342PuWQ74IMa5cNOkDf7uW0daP6
	6gaRqodqSso2nv9CApGr1BtQ/QF1RRU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=prgOe0az;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k1EJFnM2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=;
	b=ep3crCd/w4HhMEhxLNBrQQ0JnAc5XJUEdcGFxHL+tjar4jZMFELT66nh4PCOacVtoUChWi
	7R7NwOT3EGqyjZ1LUPqUfvulTTx6tUGGidznZ5IfkpxjDwz0O/kUl9ITMtDienml0STqb6
	mBVR3Pzukm/V4/n9PoBP/yl0PEUb2q4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKEWS1610873;
	Fri, 30 Jan 2026 21:00:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=; b=
	prgOe0azWEgN/a+ctz9PeZWdL1h6IvCEqyhlxcMt69mCaB/+NLuXuf8x8ieTcQst
	LdZmCubqh7R0C6o5A1wRczVwJIV7vIeltOGvjJ/M3Z6vq8uEn0KfHf4ehi78bjUx
	h0bdInHk46McMILyRX7uNl8UVCZ2up+KAPf49yHoe6fwTpsdDaDKLmD+gh91jTJq
	+X2yCUMv9eIGYNLYAzRWy/RbheAUygSmAMcncjuxFM4E8Rzbt8T9S45n9cPjmp2F
	41JhaLE8DXtQrvrK/i6Hr0fH6r5BtXC6c3WLakKmmfR92aDZiUkZGJ0vA3Ysx4XV
	liaiLFYlqHvFo5BSrojU/A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10d88bnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIkbKI032726;
	Fri, 30 Jan 2026 21:00:35 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g0t-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCFWIkeDyLpCZyDYpModd/WDQNTxp6wyXICdi0Kuf2C9zMTNpOIc/HdxojQLu422SdruoPf1ql8MpLaZYiptpwkvcPotHp7vOHhIMhZDfhXVQlPw78PIVIRU3FFu6uSaRg52zT3jnCUSEZ1NJcIG/Mwbc7wxG1nJHJqUiBC0QVIYY0kQYRnqRj1MwrCOlkfhPJujpue9AQJCxy2rC6D8iIk0dvz3m/tOfA8EiUBka0gbz2/KxGvMx6FFiuWNRUyu71WzI+G0WG/QPoIjRZGWkPk8MnWjXZ2pZd6XYjdrypD9xUsrPrTQehES9Pm39fsJLIXupXA0HbOlqJztqCm/JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=;
 b=hAcdMJniej5oorHg2uYp8T8MTHtEKzrnQ14RQBJ+2cRIiNVBXqr+XX2qdGpA+o3iX827B+qBl/MRPxFJfAcP/4Qz29yooeCi0ED2yxPN5awQhLhfi5YbYYHWGIWrUL2CSSVqiC+miDUzjg9Lbpfp5+RIV4eWlf8qAh0t0UwcRYUmPCXJZNZvwHJhz5auolmtl3puNteC94WlLHi9JCGsQCI8JpO2x3HzjGrxZJsTYqf5UCsM00XyesfiLYcXuOv/tW7qA4cPHq8bKN1CFSf67AQWej8QqAOon1NBas9day5f0YB8F01GMWl3MldEBtmAzR3k/tMlVQm9Qnw+W+gUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=;
 b=k1EJFnM2xB5/EIoTJ6TwJMsiZ50Je/Hob6NXRqFj0r3rf72CIzxxx5tjPQo9caf5rpuDP5+iDjC05jF6c3OLkOcRgx/9OEJM6pqJET/cIkBc94oxy8TzkBOybzedCqEoDYBi3A3w5LVsYx1DRKsfRQViyLmTtKFa4f4p1L+qcxQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:30 +0000
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
Subject: [PATCH v3 14/30] maple_tree: Change initial big node setup in mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:19 -0500
Message-ID: <20260130205935.2559335-15-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0092.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 2791a2de-12ad-4377-b9cb-08de60429844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wv2gFkl57tgnzleaYsbxrbzo9ExSJZuakQBI/68/btDRUsu1FCfmbPfTnoHr?=
 =?us-ascii?Q?Ik1QWJvJ/QL7gFW9PkYFxrd+tFMjw/TMltbuR5JFi8Lbh4jBu8rInEPfp6N6?=
 =?us-ascii?Q?i3SJRhDYeLa2bjFLq2aN/pdAhmwoaoLdywVl31bCWDCh5fRLpFSKVa/FGmsp?=
 =?us-ascii?Q?3ilrNn36+jPn09rCi+kuBtZHEafySwE13ZE3IruswKRGXQxpONbcas3XIp2I?=
 =?us-ascii?Q?Djm6svFktdTzZfAjxYD8B51chpatuSec/PNXBiuAfz7kL49ltQvERU2eI5EI?=
 =?us-ascii?Q?13zURUDBa+ed1ZtClTHxAVlksl8eovLW/JpZjKVZ4ua/SC+CCNwA84tibXmS?=
 =?us-ascii?Q?B4learv/xjrpTgR2zkSaKaQOE46XHu2B/iTh4Z3SyETp3pgfpweOGvbaSeiE?=
 =?us-ascii?Q?ZmoFl7yr3v87ytcqQ5g16nLoqTjLoZL9qR0ZIUL9nUq9aC+lNgKgCKb75vtL?=
 =?us-ascii?Q?HBdKzbV9no+yxqLbPS1uT8hvaWP44Dn1pZThuA6kxxanaEMg1MRA4iAdJmcm?=
 =?us-ascii?Q?6jHbt6gPPVzphg7GX6YL8QUO9Woah7F9aRjySuB4v18HoYzM/apZhFybfn8h?=
 =?us-ascii?Q?gx7N3mCDSP4XG3gErKbLiv2e/n+Bhg1OKDTBXFHEnOFpLnd5Ae69Wn4ld7oX?=
 =?us-ascii?Q?2KHmno+VnYAnm/VSqbkMCqqXS2iEu8VKVAWwl8ByHaZ+8pbYjGykLNs8H6xq?=
 =?us-ascii?Q?HWcS70NxUZAZNVxVZz0gcfAbGntCSjhqTUjxDNSG1CjZBw/B9WTongTOeVp0?=
 =?us-ascii?Q?0USZxJOX9p7PhZkr2wjntgXqrbYvpwPsFfvb3yzDlHHzRjFhxlefb5B056Vx?=
 =?us-ascii?Q?dx056lZxgRBJ8d8Z7qd7j8WR1S5pPnNpY2qFDF2ASwa7ShUHvOh46YV3IfUo?=
 =?us-ascii?Q?fTcqlk5R03sv75OsaYQDBJNZ8lR+UCxoqVWfhgOZ9E39hBqsTp1+/56/+u/Y?=
 =?us-ascii?Q?qMM0I0nuS+OQOBWIKsVsmZqiItR3Bh0rqxeubtoqOJD470zzAwyn1Z8wCZWj?=
 =?us-ascii?Q?C7GCjTsoaCq0SLe0V7iREQ1XHKEDvYqoiIsUtfBAdM8xoyNczO0MZvTlk7h6?=
 =?us-ascii?Q?7UogMhVVuNOurfKOo52X2IKFIm8vBsFC11UPOME8MBUxDzN6iecXtwhTzpp8?=
 =?us-ascii?Q?f7M9U/YQ2EvaXZGUP1w07TuAFSlQkkNAlAj2qzQKiYtwgYK+FvP3NG0BdDMo?=
 =?us-ascii?Q?Q9KQ3uQDa3RCeFYtFvnyue5/MuA07GZfok2p9XQuo3bExmNeWg3mHJqS5HMo?=
 =?us-ascii?Q?C8/zJWKKfvM1bDAxm+JOxNuy6dOvulfbOTNozfNGkQoIacdCeeMR7t13oZAg?=
 =?us-ascii?Q?0IHbd6Ld2F8tcDe/jPf7EDCdbPPwrKQlChW/Jy93nmbCCQsCuZZ7SBfiQ8I3?=
 =?us-ascii?Q?G7spJwGu32e1LJR4tQHQBefiAtH1UQhFXeHq7wB46ID7iDnptpla3ODUCB3e?=
 =?us-ascii?Q?GytlSLZDnzInFWxS2fMtr0kxKaCxIPHhcpMrhyQdw3DupYDherlaJhJNuQVw?=
 =?us-ascii?Q?F+6v91uV+2Iox/3M+UlTRHXByXugBkMM3zyXvKwwRrdJLwhhRxUvqwTvcxnp?=
 =?us-ascii?Q?Km2ce0Qn8kAzPwW394g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T+Ghcc94SN56KceUeQxgYJOpuCkKwjbp1lyqnjQv6zbb1V9X89CkT7tBch0q?=
 =?us-ascii?Q?6ESX2d9lrkDM1KlNXrgTzlsi9Lb1bk/bpArYgp6qEDGo7Ouwu9ix+lJl0HAu?=
 =?us-ascii?Q?OtjyKekpqx6RqjQIZIrPa31sj9c5Grp5QHLLL8azsMC+oOVAjR5Yhe7pLmGb?=
 =?us-ascii?Q?uInSmCQkFcDLOBLGtaoRkVog1SHXR1e4Z8Smo7Sld1t3fUTp2nGHu+qX5ZzI?=
 =?us-ascii?Q?DGVCYCKRKhOjk2kRgXqF/rcgpwQf+VBxX8rMjKmWekwk+bx2qoadQ8ifvIe0?=
 =?us-ascii?Q?ayvpHO6cp4jRoZDjhjYIMGDWj1mYOK3ocE3ytjGzagKlHzmezyqlfiJjZ/ZK?=
 =?us-ascii?Q?OJcipefBO7xqo2kDXQKZerU/yKu/qG9fdNbq3w+Z87v59x2aROrAGPyNLwsq?=
 =?us-ascii?Q?slq8HrCEzUhtUDbxE/WgJHJeFKSPYa5Y5PkqQ3f0Q3SqLUasxCjcYKCV00Wb?=
 =?us-ascii?Q?9l7ArOiJFFSV1YgDUsCypzfHUUiHrhaNw0oIol6G7BIJHjWHCXwUqXpnNLNX?=
 =?us-ascii?Q?45skKHOBQvcJrbNve133bXTfFpXYBBnvwttnQyiPRvSHgwjPB8vs8U1IHTLx?=
 =?us-ascii?Q?DOykZweg6mKyJVSYOhX0SQKjGP3V8836f3AZUqgPahNfxZZllye/fIvoGqlH?=
 =?us-ascii?Q?020hToyUUZhSeJUCzYfu84OY8yVrpreK0XloxEe4JzhYHH94wFi6DFCyUc84?=
 =?us-ascii?Q?+EAYjwj8hE+oB6vRUlczV+RML//zHXyyQUDxFxGyWS8LXr7Fx01AfquJYeQ9?=
 =?us-ascii?Q?wk7KFTkB3kwjEapazMpmGC8O9H2VKrvI8JxvGHpCIbnc6nsod8MksX+vQi4w?=
 =?us-ascii?Q?e7kcSEJ25opQRo4LktrXduN8Dij1mWeTz6z2c2h7zGcQXNeQdQqkuLOnhPYa?=
 =?us-ascii?Q?DQCVQVURpIozAryOCctTtV2v0daKmCud0uIPwKITG1hOV9cqfg3J04MnGg1E?=
 =?us-ascii?Q?006WiqijGP84Xs5oB8oCv7LKiMx6F4d00Meoq6wnJbmZRRSCCT7LlkRyLiDu?=
 =?us-ascii?Q?mxHqB9QMk4PviDSst7VEEo9LvHlzD1aNDP/kiziP+/jLsf7ITdszx7Npcjb+?=
 =?us-ascii?Q?Ed2R6/Ip34jBSbRysApT5O8NgziNPD+xqom0Ka/1m7jeUmbrGpxqeTJ9hKYu?=
 =?us-ascii?Q?g81HWWmGpKxw4QlNEvyi0P4OjQ3bmNNgKElzEbUccgOlAjYJssgPUc4ivqlg?=
 =?us-ascii?Q?u45nTt/3OaSkLwtaX8tf0yu1xz1TMVy0EOzqQgFGdg5+l523SRTYQ3YDkeVw?=
 =?us-ascii?Q?5zh96+RoOTq4o5GzU6KpyMkcq+MyJ8nfi5LV8+hwPNGfrm+3ElH16pmHb3lJ?=
 =?us-ascii?Q?XYviRxwm4UIIOy9TfVgjhJxT4BKtE8c9Selz38aq3eLb03fby5n2jzjwecU1?=
 =?us-ascii?Q?PGdrPj3/yi7cTyv5GsM5cqm4hXveJQ0lK3M9sg+BbZQZpFVuLo3tekbh27oK?=
 =?us-ascii?Q?d6lTcITEvl3CbOLvNTSxZsONr9pSuTBDNWX93C8yhsmKn7wB2UdNKjr0HtqL?=
 =?us-ascii?Q?ec8q4h9sv7FyQDmIXZNrOvtO4ZgSk3TE/7MHx2jZUcVZdXAcS3GIgz31f89k?=
 =?us-ascii?Q?2I0vutZtevcIOHaXjz20aItlwkZhOG5yQhjZguNVhGlELVqf4bbTsrxVqVaL?=
 =?us-ascii?Q?n6x/2ZdcqS/2bAYhXTFsp92S/oPb1K1R5TYwRZtiKCJEF/ruaffnbeuZv28J?=
 =?us-ascii?Q?jFhWVUpcgZkDE0IIGaUOKYfm8mFUcLXtVLHrU+3bd92NewuBZf4J7gTmou+V?=
 =?us-ascii?Q?OQzIsHrVyA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1wL1bAZlBSCfb1NmgPMGGbAzY4bIv/uLwhdMldlVutraZTNfKHvcV/LjGHfmi4ybTtvUn5IkLoq+9D/seiJdM2RSZPEzgD4wzzGAqHIzBGzhFnhnWSkPhyrkflCtryKU9Itf9UHTsTzmnl7j4lmFDDHqnI1lX3qx3Qo+GKhZTfS7xLtxFEbNfwDRQbJhVlWlegTkVOi97D+4YQPJz4cS+XWZaJ4i0er19U7pVgV3VgZpjqFw3f5ANm4EezxUlzQM94yxoGtaavAJVdSqJdtCp+6SfcxDDaO6V9LUOg+MoK3wy9G8G5Lo6T4cBWTuOAS5HFMdueWIM1qSMyIqSc/3fkYdTP7LMK7HjqOX42A0OsdPEPBaESGvVoch/8OWljFsZHEumrzwDzqU4Wp8IOJXd1wpgdAOl3S6yXp25B9HWRwfJtUdL6tsIEvPYQ0lwS5vyKobliCvRJFOYmI8l+HoiOLKdGeu1uCqasOqCA7c/ZMVWXbIAMHA/qZCoiOxvr6fpJCSF81Q/TIUv6GQ+p3Co+aoWGui1IhoER3/4JoVGJccX/+sfBCqC4kLEsfzFLwDDj6UheGAc09nYUA+d+s8UcR/jKccOoU0TM3ER3O+p7k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2791a2de-12ad-4377-b9cb-08de60429844
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:27.2784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Rw+tx7gY4GwPdK6OVC0JEgZL/l3cGxxmFC4fiQVildP1Pd78YlYLZ79XCPAzByayDGq2K6QJHGTh5BMi8Gh2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: y8ifZkgJV67ARou9smMRTVa5niyWd099
X-Proofpoint-ORIG-GUID: y8ifZkgJV67ARou9smMRTVa5niyWd099
X-Authority-Analysis: v=2.4 cv=YuoChoYX c=1 sm=1 tr=0 ts=697d1bf5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Dk5oX4W92Jz44JyhfwQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX6ubUyw/QAweM
 7pXwdhEkAZ/PCIssROIwp61oxUTMPxpdkEfqD/rZ2/PpPWRMk87j3D8d2BTIQ1NF+QON8k3X91e
 8i7o3MFxlZls7yGZ7o1C1k2E6hOONdO6QYoOOD8yFiQjEfiRsnJCaG8nSIhPtsNu3867RWEM8AE
 54LbZQRWP04uOylU4sg1wDCGGOrIerKoQrg4NawSs90/Jc0CufKTyUPb9lDtb4kXJNYVdqr4Tum
 v8PseP6XnYY6HlevxC56WuAmophOX7iLwXRir9dQsrrWokE2ppqzIS52lAp8EJ9lGPUXjPc8lPR
 T0+v9v+zXChBRFjKxFWBvHZsfrHMZRSwW5lvRnCpLpPBrpKONvEq8N6HSdIQuoGk9EdaqxPnhyS
 9IvRxoBkzSiTB05b5o+/hT7PdCSJolBsR/JdBP3fMYCY691YbHSXaD4dkJuV/9ci8dTPvnrUcZH
 b7Udwl/1RsrjYWN4GxA==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1336940017
X-Stat-Signature: bdoyi38b5nqj5d9zpk5jf4pm3bg47ffc
X-HE-Tag: 1769806871-805380
X-HE-Meta: U2FsdGVkX19e1rCB7KoFX1B0Z2jaB/F0XoAXvPKHEpUKDVY3+H5Dt6C511jEZlAqsUoBCEL6W78+MttFf0YKmOFEw16aA1tlebnBCMTd9jXmYqqLQ6oK3K62Hi9FDgCCg5MYyrtG4V65oez9fD8gGNCatIFRYNZ5GXxxcoWNaS9H8THLGDegEL3NCN5/SvalNqp4GXTy1owbXq5sg5t63aH9BsEgM6PFfLanbLDFlXEbIW9JBtnsXH3QUkDioBPeK6BV3etajZkRMCeqmpu1zt8NMba9w/ULIGxnN/PVjgBD79JVJdaopGj3nMi9i2Rc1vD42BeBZk9+4BoqpIOphnBacnaNoF5/jFuwpckx3fyaS5kUjZh/KZz5HNHCz3a6J31tP6rdk+quffG2EfUSzckmPUMg47gMTjtkqjwFmZ2DDGSH1ALAalqXU0KHPe6Y2ifoUQDO014ZaCyiUY62FL1onTIFXRCIBpRUcWTEk0xCLFFyi4H2xkyjhulv+XeffGuGSExbiJablRMqSIASyjk2t96gT0ZH7Zr4+/Ag2jNKWJrZNNT4se8GoKbOO2ETHsGtUXCz8uWk97WGprexADvGekZzv9YJxVf2M6X5e0gwHujwv32ppBfk6cB8UIcTAgXgqa05U/z32ZNlEmfbI+6aHFRVkpxqh1en3XHTLarvCs5+OOFSHojDkBrERo4iZx/bqBZ/J025iISf2qlwqrL5wfLDewO/551eoV5omEYaLhzBu+0hP0pboBH70Mr8lcow/1gJuJPZQbKTFtEpigapeiWIpyLsV4F4D0Ub6FDCpkC78mLv157EWOhFMQ9nAl6ypIKGqrh3PIgPwg7AV1X8lONTBY9+0ir+FSU2j+Li31gbQGvTcr182YPiD/Q3cT3PSXUjLQv4DOpKoNaFptBKjiU52QXvVz7+sBQU5mTAdq/P8fguArb0H23/NmONGOaRjl3r0k8aO191Cfu
 j/AiOT4n
 g1nhaIqGY8cFHVSBSTzxqpPSN2UJNhOBa43/ppopARXYA1C46Aj+ISOGD60X9CWFGUISzV7L/uuHD7y2Lb8oIf6y006qznUSo0WVKTXLxVWvzXreAI0PrvC8I6ryvpeHZxzkDRUx00FPwjg4GT00Ey9ZjwQQEBqX/HGO1VvAuuuqYr0kAqmzCxCWh3KGbyFuwZ/fuXVA6ytbc8yxRTSzxJnJXdIyw4M7XrxtfbheqkgIZU/Pbg9UiPeqpbVTsKwB7sZqHcSU6xGJz1tM5QYiSVXD825ZFDsTQHJ/qKwHCf1h4QKDApKrlxfPmd6Wz0Cj7yrIitJOJbMkJykAHUd7PbPs+FQFPiH+BB/KT2kz/+WATd3lQ50e1juANPYRsbYhCn0UdmEudSDSaFi56S5QE9dVLJnVeABzMIlk4iS1PM/KQEyw6rPiT9IkUaqyDCYGa1A7tIldn9fYspQINMHDjHfQ4SoaXK13XWKMczWhnDsKA+FyCIXCuh1gfJIeIbwYfzkFSHp5BwTYaxWNUdVfIFcZoe3Gv2p2pbe620m74td/5v/NZe76RySsEpOtsSMoK+f6REYK4zjt9SHuILEuFqUb6FcN6S1vt7ahrs9miJ7LsxYtc7YTmW2Qn2lau8HCyET9/NVSko7uwFAjhD2mfrKDV86RzXRsJYBbGbQF6eFgGQkeA1AR6HpHyBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of copying the data into the big node and finding out that the
data may need to be moved or appended to, calculate the data space up
front (in the maple copy node) and set up another source for the copy.

The additional copy source is tracked in the maple state sib (short for
sibling), and is put into the maple write states for future operations
after the data is in the big node.

To facilitate the newly moved node, some initial setup of the maple
subtree state are relocated after the potential shift caused by the new
way of rebalancing against a sibling.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h |   1 +
 lib/maple_tree.c           | 175 ++++++++++++++++++++++++++++++++-----
 2 files changed, 153 insertions(+), 23 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 9bc7fa89bc2ee..e99e16ac1c6da 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -177,6 +177,7 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char data;
 };
 
 /**
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a9b7e398c7dbd..0d6f810a4a1fc 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1304,6 +1304,18 @@ static inline unsigned char mas_data_end(struct ma_state *mas)
 	return mt_pivots[type];
 }
 
+static inline
+void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
+{
+	wr_mas->node = mas_mn(mas);
+	wr_mas->type = mte_node_type(mas->node);
+	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
+	wr_mas->slots = ma_slots(wr_mas->node, wr_mas->type);
+	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, mas->offset);
+	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
+				       wr_mas->type);
+}
+
 /*
  * mas_leaf_max_gap() - Returns the largest gap in a leaf node
  * @mas: the maple state
@@ -2258,6 +2270,44 @@ static inline void mte_mid_split_check(struct maple_enode **l,
 	*split = mid_split;
 }
 
+static inline
+void spanning_sib(struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
+{
+	struct ma_state l_tmp = *l_wr_mas->mas;
+	struct ma_state r_tmp = *r_wr_mas->mas;
+	unsigned char depth = 0;
+
+	do {
+		mas_ascend(&r_tmp);
+		mas_ascend(&l_tmp);
+		depth++;
+		if (r_tmp.offset < mas_data_end(&r_tmp)) {
+			r_tmp.offset++;
+			mas_descend(&r_tmp);
+			r_tmp.offset = 0;
+			while (--depth)
+				mas_descend(&r_tmp);
+
+			r_tmp.end = mas_data_end(&r_tmp);
+			*nneighbour = r_tmp;
+			return;
+		} else if (l_tmp.offset) {
+			l_tmp.offset--;
+			do {
+				mas_descend(&l_tmp);
+				l_tmp.offset = mas_data_end(&l_tmp);
+			} while (--depth);
+
+			l_tmp.end = l_tmp.offset;
+			*nneighbour = l_tmp;
+			return;
+		}
+	} while (!mte_is_root(r_tmp.node));
+
+	WARN_ON_ONCE(1);
+}
+
 /*
  * mast_set_split_parents() - Helper function to set three nodes parents.  Slot
  * is taken from @mast->l.
@@ -2642,6 +2692,49 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 	cp->end = end;
 }
 
+/*
+ * cp_data_calc() - Calculate the size of the data (1 indexed).
+ * @cp: The maple copy struct with the new data populated.
+ * @l_wr_mas: The maple write state containing the data to the left of the write
+ * @r_wr_mas: The maple write state containing the data to the right of the
+ * write
+ *
+ * cp->data is a size (not indexed by 0).
+ */
+static inline void cp_data_calc(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+{
+
+	/* Add 1 every time for the 0th element */
+	cp->data = l_wr_mas->mas->offset;
+	/* Add the new data and any partial overwrites */
+	cp->data += cp->end + 1;
+	/* Data from right (offset + 1 to end), +1 for zero */
+	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
+}
+
+static inline void append_mas_cp(struct maple_copy *cp,
+	struct ma_state *mas, unsigned char start, unsigned char end)
+{
+	struct maple_node *node;
+	enum maple_type mt;
+	unsigned char count;
+
+	count = cp->s_count;
+	node = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	cp->src[count].node = node;
+	cp->src[count].mt = mt;
+	if (mas->end <= end)
+		cp->src[count].max = mas->max;
+	else
+		cp->src[count].max = ma_pivots(node, mt)[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
 static inline void append_wr_mas_cp(struct maple_copy *cp,
 	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
 {
@@ -2670,6 +2763,42 @@ static inline void init_cp_src(struct maple_copy *cp)
 	cp->s_count++;
 }
 
+/*
+ * multi_src_setup() - Set the @cp node up with multiple sources to copy from.
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The sibling maple state
+ *
+ * Note: @sib->end == 0 indicates no sibling will be used.
+ */
+static inline
+void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *sib)
+{
+	cp->s_count = 0;
+	if (sib->end && sib->max < l_wr_mas->mas->min)
+		append_mas_cp(cp, sib, 0, sib->end);
+
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(cp, l_wr_mas, 0, off);
+		cp->src[cp->s_count - 1].max = cp->min - 1;
+	}
+
+	init_cp_src(cp);
+
+	/* Copy right either from offset or offset + 1 pending on r_max */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
+	if (sib->end && sib->min > r_wr_mas->mas->max)
+		append_mas_cp(cp, sib, 0, sib->end);
+}
+
 static inline
 void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
 {
@@ -2873,36 +3002,42 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	struct maple_big_node b_node;
 	struct maple_copy cp;
 	unsigned char height;
+	struct ma_state sib;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(mast_l_mas, NULL, 0, 0);
 
 
-	mast_l_mas = *mas;
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mast_l_mas = *mas;
 	cp.s_count = 0;
 	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	/* Copy left 0 - offset */
-	if (l_wr_mas->mas->offset) {
-		unsigned char off = l_wr_mas->mas->offset - 1;
-
-		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
-		cp.src[cp.s_count - 1].max = cp.min - 1;
+	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, &sib);
+		cp.data += sib.end + 1;
+	} else {
+		sib.end = 0;
 	}
 
-	init_cp_src(&cp);
-
-	/* Copy right from offset_end + 1 to end */
-	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
-		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
-			       r_wr_mas->mas->end);
-
-
+	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
 	b_node.type = l_wr_mas->type;
 	cp_data_write(&cp, &b_node);
+	if (sib.end) {
+		if (sib.max < l_wr_mas->mas->min) {
+			*l_wr_mas->mas = sib;
+			wr_mas_setup(l_wr_mas, &sib);
+			mast_l_mas = sib;
+		} else {
+			*r_wr_mas->mas = sib;
+			wr_mas_setup(r_wr_mas, &sib);
+		}
+	}
+
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
@@ -2917,12 +3052,6 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	mast.m = &m_mas;
 	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
-		mast_spanning_rebalance(&mast);
-
 	height = mas_mt_height(mas) + 1;
 
 	/*
-- 
2.47.3


