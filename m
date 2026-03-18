Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEB3103E16D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C566B01A0; Wed, 18 Mar 2026 08:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724716B01A5; Wed, 18 Mar 2026 08:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDE36B01A7; Wed, 18 Mar 2026 08:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47C6B6B01A0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:25:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 120F51B884A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:25:15 +0000 (UTC)
X-FDA: 84559103790.27.D007922
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023129.outbound.protection.outlook.com [52.101.83.129])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0B7BA18000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:25:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=yKk0kX7E;
	spf=pass (imf06.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.83.129 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40SkeT+xOQqY86CZOKXGYQUbjER0F2fZ+s0KRJAdKRA=;
	b=MSM/Djetww71Sfhgln0kgnteXe3cnlY05kjSKBKeEnoT3qKz2Bg9yICA89Y+SzyMw9YJh7
	nbrWac7XcaNIy/jRaRXjLH1Pwj+bKe8jy4uVEe9NpdIlmYDKzwIA+8onWavpxRQzQRoR1c
	7iwrNETF4y7izB7Qsja7QY7x6l3wez0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=yKk0kX7E;
	spf=pass (imf06.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.83.129 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773836712; a=rsa-sha256;
	cv=pass;
	b=ZmyTr8geAJmqGdctyTdgVAGg8Y3ZsuTwFaNx6QaMtVDt1GjCMHTav1st7YewFtd+h5VeOG
	JG58m0ETfsthyIC8dxNWClzbbqeZFQbJp2d+HAhma+5haJdaV6MAiEwY5ITUB5d54xYLVM
	My6av7JJ7WQnIkIdapZa/6WceWSx1ds=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+Cgp4tl3C++++iIjUV1Z3Q9wlwUGlvPWpKnGbBiVP7hCeJ4ywfZ0JxOHNZAsx3WNUFBNWNzIPP3V/FTWdi7+ZZTuVU+0fFL7c69rAIEUXEPU6EGtDrRGPFdMJDJO2D9S+BV6s6D9d5SXPdXZbKVuCoJ/ZwmZzkKpL5tZduoesu1Y5pHlUy9e0j6XRvuE6mY4IlsIbmGqm/4M5NuOcwNEWUiujQ+/W50Kfi53hNeFK44bWpTvxjBCuT1076OwWK44kz9qCkzoss4vGhupM22EmiVExhx0yNxweng8sVUoGvhc7Hh57e2CSGLI41dUkipkfVzrA6xcl4moKyAC1PzJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40SkeT+xOQqY86CZOKXGYQUbjER0F2fZ+s0KRJAdKRA=;
 b=Cjsn4SYUbsamvv3ufIYfEHLMz7pGoG5oSZVxtCa4uexmFCYjFQEAyWKeR3k6QD8MmP8OSPLV4w6BSi5wn9tInq5KkrKlKa0kt6wW5Hmw0KyFH6Xbyuaud8SQF/O8hkEJYIVFHDeJtDxInfo618JNkHtV4JrFiWXnvJGISTJG+GTeCHjQTFDGfHKDAvmhGumvt5XmJ/Epk17LapccoVJgQI3uOf/d4Z/dCRSGSkPjsVlMstuD1QfnCeFnAprxxXTIBYp49UOulkDfgD4zrMYw6HOlT3jvDblNZun2rYGtg8rGA6iggeXTomj2sQLcIXI3cW7OckgONYBSHnXcG9za1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40SkeT+xOQqY86CZOKXGYQUbjER0F2fZ+s0KRJAdKRA=;
 b=yKk0kX7ElKtDgeHZuKKEzsGOatWj76phk7Aup0/PpVLLU9gN+zvR+7sa2AKnquBa9Xk2hu2BlATaQ0QETMkUgKTg8A8xsSfFu465nx+fLk2aP/oMUJsflnA8mop/3hA70MgX5auQ0AKN82+PbO8H8cYhN0x+iSYV2qPQn+D9EeG/2OrAZDpnkOIB4okH4FQ9E/7s98XaxD/KiPoBOAY3MIZc6/VXhIybbgM5YEnGnNg08yqJ66Rrf194O1VPz4r7KiHO7lrAhENs6YPg91Qii+6qh6+XKc0v3rkT4JxmS6XsViQc7dwBRGxMoPaRvHGyuUFfdgUlwPRg9v1hmyhcAw==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 12:22:13 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 12:22:13 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 4/5] selftests: Add tests for creating pidns init via setns
Date: Wed, 18 Mar 2026 13:21:52 +0100
Message-ID: <20260318122157.280595-5-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
References: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DBAPR08MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c24522d-d8de-4569-2165-08de84e8fc4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|52116014|376014|366016|10070799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Jr+RcmS4+VYrcJgHgqaLDhZ2iLU32zyA/Vbzl3A4rgoP8OkAIkklto43KrHiea8QrV/XS/137Tlvqsb/fccVBLdZc12VH3NXq+WtnV+8KYEb76Bk4mlBdohhqLH03h6yy+wuLLPqtXOiYWFESyQareFJBmOmk2yjxVUn8FUPdw1BGmoyt/CY4REXOMEJfG0kfcG5YcBOkQTxA6drNQJoAGmJQmlctO37idO4+ztR0P8+8H48PeNFg/wwOZPb3EvjnwqDIZOg/llJVxIcCaAKp0Zap8pIc9ECR/v2m6LIz0A+Lc8icXG/cNlsGY23sITyxvJARLigeYme9faq8lce5uJpkF0eR14gOcHNdwdj1eJu9OkArhd9pjMI5nfj1q4HyKo4lEvpwyS7i9wlqjBCuu0jES9hLVKjdE9uijm/vrgpKKIILTEMLv5EpsohuwdfZ+Wp4LUALx13HYDLVIvDdU5SaxoWI8YVhzr70jTg9Q2V4WMnTDCpOclwYWyPaOWWFhJCRyvZcp25lj5VuQuCCiguSspPMgixg06hkyngDgswJqlV8VzFpNbRk4PPgXf0R/QiJWjyBog8gXu2J03wJq8lYum5aXVEGPj6a7tBhROGp27P2/Q4Ky8B4GnDIfiAX5SgI/V9V1V1uivB17hmmBg1vGKqJS4u27mxxoMRGsK7qi/egwPVqP+ocn7NbnHuffxRcOEQwwha0Im9Ass8VYDn2QI5yspJgAbd6+kcreE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(52116014)(376014)(366016)(10070799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5YcpixGNZThqDLhSY8ANrTlPF4BbbH4PoZEvDn/9XwTGTCQ/ULntObl5qt4E?=
 =?us-ascii?Q?Kj13dJ8K+s1YihUJz04jw4FPAAkGhbwz9pg5BkL5twYbEodolQFABmCWCp69?=
 =?us-ascii?Q?6kVqpuzKGYtXp0DHq+nu1ihwkbZtHhnHMXyaV4bEwNk4luJ1lPHG2Eeo33zj?=
 =?us-ascii?Q?Pq+Qlf5ug2yzN9JE7pAjTWfvwo8oMTyyNbcoVcPmpnV84jStE35R5heuTf0l?=
 =?us-ascii?Q?gbSJE/wupHo7x24L/AtGJtFtmflp0Q/BSqfTOW90fi5l2SNewkINmqXYvlx6?=
 =?us-ascii?Q?WgkJjUGTonRhkC5LfUKbrGa2Ct5ovxqEF/D0sQ1JxwXJOq90yIBEP//22dfh?=
 =?us-ascii?Q?xpaxdxBg74fWGxydG4ddw3ZGKpDK/VdaklElNg3SrEUONmcTkSthIeDcVP8q?=
 =?us-ascii?Q?gGdObo3HIBmgNMHNauaWrQxQ4kGnLLzQLchVn9WppugsG9OQYQsPcWo8Fm10?=
 =?us-ascii?Q?81OavKnBN+pMSlpie/RYtss1RXzpRTVp+e1BLiJrjdtuRmc8W7uIIxCLIy0I?=
 =?us-ascii?Q?M9b7WknWvXjWeO7+YdrFGJwM0oYbvUGx9BHPDLMlhMp3TXTK/0+mfr2Ha7w+?=
 =?us-ascii?Q?2nPMg13A2JCAS5yMqBKIS6dpv8KzqdqLmoXNF0HBLYrkIlgchDvFq4liV/WA?=
 =?us-ascii?Q?yZ0JnOx+m2gpIBFeKb3+QPdvC2KWM7ccW2OUQ7Ik2rMnkq+YXsXlOAVGbslh?=
 =?us-ascii?Q?RHJTElzi8ieb6fgsXFJGiABEfeKdNkXjqEegm5o9tP+xYGtiRVJCKevQi/Yz?=
 =?us-ascii?Q?qXcxjsdBrkl29CG1TSIZ/tLTK3T07sZy94Z6QXw3ZAS2AbrWWmfObp+OyHmE?=
 =?us-ascii?Q?LHY0CkSzzJdhAg8j+vTPU3w0QUH6aypAIkEitfWJw02vYfeBs73E+pepwjLE?=
 =?us-ascii?Q?u/UdUvxkH4dZmqRprGbw42kw6t8WKk+US1nZn+xyeZ7G6N156/C5a1XcQwQw?=
 =?us-ascii?Q?BlUXLW8i6qfnqbYZ2XrIT65l3uUGMFY+uofACwMeBXr6nc4J38S5ju7/ld6T?=
 =?us-ascii?Q?2ng0mYFdH6++ODF5P7qOrrmsIZQu4Q1gF9JLFjvRxng7WfI8AD6Stys2d2s5?=
 =?us-ascii?Q?fxfNJngR6VL4f85Vi72XFnCVMAKKa5F8JTcw0tccIHhznjAEbZfWgEWyw1xL?=
 =?us-ascii?Q?vUKs3Ht0ABs/4R918IX6Y3PPDBqjxRDbYleohvYGZHDh/ZK63ojpJCJJvtHE?=
 =?us-ascii?Q?C3nQyyWvR9I09Ev62nA5RN0mPhMUDbhdNh3NMlDZoeuoxZ1OYRH1rmdN595P?=
 =?us-ascii?Q?Q69OBp4rj8cbBGLKNx60eIPdCkY67sysPGIu6KFuHKfgnOk6rE64My7+riMz?=
 =?us-ascii?Q?MxlWf8Bl7K7bS47F82arl28BjRmTkAOSKzjs+QWic/LoQSiekFpX4gHg3Fte?=
 =?us-ascii?Q?mTXqT8fzNzAIhXFKaA+er//oLpnqzeXjHpGRhJKleZPJTuhqfmUJBoRMQ7Fd?=
 =?us-ascii?Q?BdAZ6vODQ5g7fCsVWhWZG2SfgCA9acJfmBiwVyj05qLtMdnnG9+Zd2D0mFja?=
 =?us-ascii?Q?U4L0GRxRnESNmMlFcT+c53Ka4zQlkeUwXW6PnS9BHajY2r2Z87HvjgM2qdm3?=
 =?us-ascii?Q?UcjrywBETG5q3Aw+Ocuq0pl6koPj8FhqGJFJ3D82uqV5gzbIE2wz1MS/AqUW?=
 =?us-ascii?Q?JOlRDhiTKLvSUp/Uc/kgq8uuSxE+hAl8txlhMEuH252cJHX3IRdNmvBP5jey?=
 =?us-ascii?Q?l9sEjhZkh53HfjeDdbhZ0eLyhh3EEPcH1HI89PP5AaE9SqSBF789auuUNE6p?=
 =?us-ascii?Q?fa1SCnnJMHlJPx1dhQFlGQgyXEP5qOoWhdJGq31JvT7HUmTbC303N+wlB+SN?=
X-MS-Exchange-AntiSpam-MessageData-1: M1XtmdMrS4UyB3aYGqJTLC0oLMccuV39DW4=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c24522d-d8de-4569-2165-08de84e8fc4d
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 12:22:13.5649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARDOOdbtRS4o2W0a8eZEp3aDsKgW5O5lrLn/UpElwsyux1uZVqlzWb1+QKWnR0Gq9QKfLszKCzayh/vRnqn3c8d/H2nuiMk+2tF+8rbLUag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B7BA18000B
X-Rspamd-Server: rspam08
X-Stat-Signature: chyfxjku4xcigu11rwpckfqwws64nsbq
X-HE-Tag: 1773836711-954018
X-HE-Meta: U2FsdGVkX1/hWj7U4JtUBxMEI2io7d+4IkGuwMSYJJQBuzPb5EdSzmgosyg5Hf/qhNwXYiaSXMpxwPvUQe8212gtNCYBHrfRva1boN8nvtcWxDZSYKbq76yB/dlxfov4ZuJMearF7N9x0JRpnQL9fOZnicTbcevGpDreu7hAItBW8nPZxrMp7P42jtoAUbsppjKuPrC3KVAoeGOeoX8o6Q9tdp/QMmv/72QQ48UYiu70130n/dSn0Tzvhx58mzjdaNWKeN1Mzyy3IwC84M2SjHCASRaMbxQKlJYLMBkqT8CGIGweYV7JnHEdrayWvL1ahkpWxtpkN5kLBCsD30YueknBfBjf8HWs+0E2WwKByyqj/5oLCDlxkMtn45Pd5ATkoxKHNoHSaK6zFPSuNmYPGjVhT5SAXeAtoaviqvAwJm44c1QGfYbLMNztWgWpM0HVP0/gVvRZa9RccW53OC2tpDmE6f93Bte2n1IqolXfN3WEOEi2udZQUlB+VHorLRHN+p2buAlL+W/1yrrskcJrZN9U6ZLsB/wfVEgIsbJqUfg7sk1q+G1dNkBQAWOhL/liXieZYrRYdwXWhBQVjYoI7LiALENDT9KeefFmawp02Pos2M8XXpaDco0TMcTlBOnBcGOr/2b8mwiNb7l0ChON/w1vIbxM76Bg12ydPNvcN31H7Sxz0eZOCFIhUROGeq5iFgqfgJt2AHoteaiksOJ26tCc7VB4cqDYe8JUBKuDZUum2be3K2iKOivpgw7jsrNF/Fs9tDWxqGCat1JczrjYBlwhwpnmhJ7ink+h+z8X80iHyj1ycUHipimXn2PhD1jy61sbH/BbFc0Wwba/bLKJfXOWdMbBShpDyfzdVyKyORsYaGgigcxWQJtRiCD5BkJw0BaDXCEnJSQN6hm3aesb0boicZzPhqZQHapq6LgG8n5ovf8oo4X5y49kr5mCDvCYOrNBbr9c/dieq2WZy/V
 APUHqtoy
 r+sUPsI6TnXCr3WBmC6wt4/Bx4ZkNZowiOyvhOC76l8XoFq6wersLGZyFofb8RBn7erCZBxvnN8eJQf9CYwB0aDD62D5a2mUWKOhSMuZNM0hsaCtYKtrHh2J+jEuymqLEGiXmleBKPMZlqGxXlLbcyMtz30czIOh2SdVrLszum97sgkRM8BH9OpBRULTUAuwN6Tdb7zHqQNBUcgSFwZdhbrCkCS7DD6e5QpZkgdP7Qhd8rYq6FLH0djowuuo0535KZS/HgoWUYBu8V1vOn2jo/xSKpkhaRc1p3Ia7UdTqQ9UyrdE1uZWxhXeWQAC52Oh9KMaYba7RNXcpyiiOX4kD2dcqPXYIsSmFZwabO2mtjpOSTK9yl0iDgm0Yg2ZxY5xrINORl6WVFgWpRS4eL5YjggEmunXiprfX5Oe0NDtXQ/X4us+iFdFZpc8vgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First testcase "pidns_init_via_setns" checks that a process can become
Pid 1 (init) in a new Pid namespace created via unshare() and joined via
setns().

Second testcase "pidns_init_via_setns_set_tid" checks that during this
process we can use clone3() + set_tid and set the pid in both the new
and old pid namespaces (owned by different user namespaces). This test
requires root to run to avoid complex setup for wrapper userns.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

--
v6: Move wrapper userns creation for unprivileged case to the top of
pidns_init_via_setns. Make pidns_init_via_setns_set_tid require root.
---
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 3 files changed, 240 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c

diff --git a/tools/testing/selftests/pid_namespace/.gitignore b/tools/testing/selftests/pid_namespace/.gitignore
index 5118f0f3edf4..c647c6eb3367 100644
--- a/tools/testing/selftests/pid_namespace/.gitignore
+++ b/tools/testing/selftests/pid_namespace/.gitignore
@@ -1,2 +1,3 @@
 pid_max
+pidns_init_via_setns
 regression_enomem
diff --git a/tools/testing/selftests/pid_namespace/Makefile b/tools/testing/selftests/pid_namespace/Makefile
index b972f55d07ae..b01a924ac04b 100644
--- a/tools/testing/selftests/pid_namespace/Makefile
+++ b/tools/testing/selftests/pid_namespace/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -g $(KHDR_INCLUDES)
 
-TEST_GEN_PROGS = regression_enomem pid_max
+TEST_GEN_PROGS = regression_enomem pid_max pidns_init_via_setns
 
 LOCAL_HDRS += $(selfdir)/pidfd/pidfd.h
 
diff --git a/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
new file mode 100644
index 000000000000..520835ca42ed
--- /dev/null
+++ b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "../pidfd/pidfd.h"
+
+/*
+ * Test that a process can become PID 1 (init) in a new PID namespace
+ * created via unshare() and joined via setns().
+ *
+ * Flow:
+ *  1. Parent creates a pipe for synchronization.
+ *  2. Parent forks a child.
+ *  3. Parent calls unshare(CLONE_NEWPID) to create a new PID namespace.
+ *  4. Parent signals the child via the pipe.
+ *  5. Child opens parent's /proc/<ppid>/ns/pid_for_children and calls
+ *     setns(fd, CLONE_NEWPID) to join the new namespace.
+ *  6. Child forks a grandchild.
+ *  7. Grandchild verifies getpid() == 1.
+ */
+TEST(pidns_init_via_setns)
+{
+	pid_t child, parent_pid;
+	int pipe_fd[2];
+	char buf;
+
+	if (geteuid())
+		ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	parent_pid = getpid();
+
+	ASSERT_EQ(0, pipe(pipe_fd));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0) {
+		char path[256];
+		int nsfd;
+		pid_t grandchild;
+
+		close(pipe_fd[1]);
+
+		/* Wait for parent to complete unshare */
+		ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
+		close(pipe_fd[0]);
+
+		snprintf(path, sizeof(path),
+			 "/proc/%d/ns/pid_for_children", parent_pid);
+		nsfd = open(path, O_RDONLY);
+		ASSERT_GE(nsfd, 0);
+
+		ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
+		close(nsfd);
+
+		grandchild = fork();
+		ASSERT_GE(grandchild, 0);
+
+		if (grandchild == 0) {
+			/* Should be init (PID 1) in the new namespace */
+			if (getpid() != 1)
+				_exit(1);
+			_exit(0);
+		}
+
+		ASSERT_EQ(0, wait_for_pid(grandchild));
+		_exit(0);
+	}
+
+	close(pipe_fd[0]);
+
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	/* Signal child that the new PID namespace is ready */
+	buf = 0;
+	ASSERT_EQ(1, write_nointr(pipe_fd[1], &buf, 1));
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(0, wait_for_pid(child));
+}
+
+/*
+ * Similar to pidns_init_via_setns, but:
+ *  1. Parent enters a new PID namespace right from the start to be able to
+ *     later freely use pid 1001 in it.
+ *  2. After forking child, parent also calls unshare(CLONE_NEWUSER)
+ *     before unshare(CLONE_NEWPID) so that new old and new pid namespaces have
+ *     different user namespace owners.
+ *  3. Child uses clone3() with set_tid={1, 1001} instead of fork() and
+ *     grandchild checks that it gets desired pids .
+ *
+ * Flow:
+ *  1. Test process creates a new PID namespace and forks a wrapper
+ *     (PID 1 in the outer namespace).
+ *  2. Wrapper forks a child.
+ *  3. Wrapper calls unshare(CLONE_NEWUSER) + unshare(CLONE_NEWPID)
+ *     to create an inner PID namespace.
+ *  4. Wrapper signals the child via pipe.
+ *  5. Child opens wrapper's /proc/<pid>/ns/pid_for_children and calls
+ *     setns(fd, CLONE_NEWPID) to join the inner namespace.
+ *  6. Child calls clone3() with set_tid={1, 1001}.
+ *  7. Grandchild verifies its NSpid ends with "1001 1".
+ */
+
+pid_t set_tid[] = {1, 1001};
+
+static int pidns_init_via_setns_set_tid_grandchild(struct __test_metadata *_metadata)
+{
+	char *line = NULL;
+	size_t len = 0;
+	int found = 0;
+	FILE *gf;
+
+	gf = fopen("/proc/self/status", "r");
+	ASSERT_NE(gf, NULL);
+
+	while (getline(&line, &len, gf) != -1) {
+		if (strncmp(line, "NSpid:", 6) != 0)
+			continue;
+
+		for (int i = 0; i < 2; i++) {
+			char *last = strrchr(line, '\t');
+			pid_t pid;
+
+			ASSERT_NE(last, NULL);
+			ASSERT_EQ(sscanf(last, "%d", &pid), 1);
+			ASSERT_EQ(pid, set_tid[i]);
+			*last = '\0';
+		}
+
+		found = true;
+		break;
+	}
+
+	free(line);
+	fclose(gf);
+	ASSERT_TRUE(found);
+	return 0;
+}
+
+static int pidns_init_via_setns_set_tid_child(struct __test_metadata *_metadata,
+					      pid_t parent_pid, int pipe_fd[2])
+{
+	struct __clone_args args = {
+		.exit_signal	= SIGCHLD,
+		.set_tid	= ptr_to_u64(set_tid),
+		.set_tid_size	= 2,
+	};
+	pid_t grandchild;
+	char path[256];
+	char buf;
+	int nsfd;
+
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
+	close(pipe_fd[0]);
+
+	snprintf(path, sizeof(path),
+		 "/proc/%d/ns/pid_for_children", parent_pid);
+	nsfd = open(path, O_RDONLY);
+	ASSERT_GE(nsfd, 0);
+
+	ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
+	close(nsfd);
+
+	grandchild = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(grandchild, 0);
+
+	if (grandchild == 0)
+		_exit(pidns_init_via_setns_set_tid_grandchild(_metadata));
+
+	ASSERT_EQ(0, wait_for_pid(grandchild));
+	return 0;
+}
+
+static int pidns_init_via_setns_set_tid_wrapper(struct __test_metadata *_metadata)
+{
+	int pipe_fd[2];
+	pid_t child, parent_pid;
+	char buf;
+	FILE *f;
+
+	/*
+	 * We are PID 1 inside the new namespace, but /proc is
+	 * mounted from the host.  Read our host-visible PID so
+	 * the child can reach our pid_for_children via /proc.
+	 */
+	f = fopen("/proc/self/stat", "r");
+	ASSERT_NE(f, NULL);
+	ASSERT_EQ(fscanf(f, "%d", &parent_pid), 1);
+	ASSERT_EQ(0, pipe(pipe_fd));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0)
+		_exit(pidns_init_via_setns_set_tid_child(_metadata, parent_pid, pipe_fd));
+
+	close(pipe_fd[0]);
+
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	buf = 0;
+	ASSERT_EQ(1, write_nointr(pipe_fd[1], &buf, 1));
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(0, wait_for_pid(child));
+
+	fclose(f);
+	return 0;
+}
+
+TEST(pidns_init_via_setns_set_tid)
+{
+	pid_t wrapper;
+
+	if (geteuid())
+		SKIP(return, "This test needs root to run!");
+
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	wrapper = fork();
+	ASSERT_GE(wrapper, 0);
+
+	if (wrapper == 0)
+		_exit(pidns_init_via_setns_set_tid_wrapper(_metadata));
+
+	ASSERT_EQ(0, wait_for_pid(wrapper));
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0


