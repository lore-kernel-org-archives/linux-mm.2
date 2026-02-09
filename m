Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4AF8EF0714
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39C46B0096; Mon,  9 Feb 2026 01:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C923C6B0098; Mon,  9 Feb 2026 01:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BBC6B0099; Mon,  9 Feb 2026 01:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 997CA6B0096
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:11:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 332F11606F5
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:21 +0000 (UTC)
X-FDA: 84423895962.08.AD00701
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3411F20002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="13/Hc8eD";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.198.24 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuNX2/bfUoi4BGUO3MtdvWGsFfEgw11uVJsz6wEavKE=;
	b=D5TqDZRZs3/XiwJVK72+A+hxppxN+YCUV6RHa4Sp6AeFnXfDrspYHLbTkO9DFB/qXyNZlF
	QYwkb5P2xFo2r+0wNUiC6bnSDDQMZd3S1IcrbFHDXkWdZMm/2Z/Ze4nSVdJ46VFepEFjn7
	H9sL/52Eb1NR855Dgfo4GZ3J9gVJuP8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617478; a=rsa-sha256;
	cv=pass;
	b=wvh4WrFTcjiZKA9qooW3K4aNA8MDzfa6b3UoAcnxVsM6HipLTOKz7Wg29tEmNflffdAdwA
	9pbhtxDvxHVVA8qnbck9GLznto1Bj8TlFnZ8FDnkZtY+GOLizjY0hbqvnc9HXA9LoL5r+g
	7oMcE4ZuHmT0S4rWk0eSKmLh+GGznfA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="13/Hc8eD";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.198.24 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VwV0L1CA8jgiIv/TdzRlg+j1dd647F/f15nXG6URN9sorn1OKUUFHXwVv+MYitA67bqWWpFkrEwp/+P3MArMMaHigNwG0i+IHZV6Tf5+pn5c49GMoaEW2oC6pC/Me326u+ZvAK2EKOFo+usKRO672m1yfIE57+H/3zr1WHCX+8wN3zxS4wdRTMY3rRyTjnauXUQK0Xtic8UZz2+MhBNcaEHZN3Danq4TUh4dG02LAz9u1a0P+04kKbHnLMOCJyPJ/BOKQoUkjqtBtRizbByiC7v7AUc1fYmOB4BnyQTfLuCnTmqUqHjpaOrP/7he8uiibltrlOXo3w14vL8nxYJpIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuNX2/bfUoi4BGUO3MtdvWGsFfEgw11uVJsz6wEavKE=;
 b=BSQHSH9cu0/XsL7Gbs++eAhegMt8u05x4V8Uzy/cG3aS+BeRlb2RDvde8F3Jff7MeKMuDvXQ6ReDFpGG/e6C+Er/KTXgoacgYcPekghXibXqUHGEUG2CWPv37k+a4tQvjNR0j7bxBboyIr2bUeCwxjfmgr7a5zOYcUQd9Vagg6zP5c78fvUqFjCWgcSgu5m/ezvy62/2MlNdDbxM5hGhMX+ES8JFbu56JNdKrVYmwc+bXBuI95qyNVgadnQgh/ezKI/P6+mnoLxamr17q95OsITwyfyT5ELGgyiu6L5rOOnIhIfmzN5j9A8gBVKYI/Z8XiATnvkfbDEMP+y61xZF+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DuNX2/bfUoi4BGUO3MtdvWGsFfEgw11uVJsz6wEavKE=;
 b=13/Hc8eDia/XN7J8+rxAq9RDCb6RtMui3sVERT/ZUlODMEIUgmaUKu0emQJl47UDHPDpqKUONv45G7CStp7N3bfjtG0ERyrcnr87FL4rnTt86Epxfuzw0da3mekM7/EqOLXxWXXQP+Ku3WVdQ8ShhGJTY8Mhy3u+CAf1HlVMOpQ=
Received: from SN6PR2101CA0020.namprd21.prod.outlook.com
 (2603:10b6:805:106::30) by PH7PR12MB7308.namprd12.prod.outlook.com
 (2603:10b6:510:20c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 06:11:13 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:805:106:cafe::32) by SN6PR2101CA0020.outlook.office365.com
 (2603:10b6:805:106::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.4 via Frontend Transport; Mon, 9
 Feb 2026 06:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 06:11:13 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 00:11:09 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Philip.Yang@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v4 3/8] drm/amdkfd: Implement interval tree for userptr ranges
Date: Mon, 9 Feb 2026 14:10:42 +0800
Message-ID: <20260209061047.3881808-4-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260209061047.3881808-1-honglei1.huang@amd.com>
References: <20260209061047.3881808-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a79a6d-39fd-4799-44b0-08de67a206ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NG0TYTIH1vnPR8g0Ul4vQkCQGb6ZshGFh9wHQbOr+UWAVJTwh9pw+vwnMeLy?=
 =?us-ascii?Q?S7qD8c21ssqJMVMkYjaoP3rbn0ogJIviCVyHu+IPJ7HTrft1AcsvDUek2fid?=
 =?us-ascii?Q?5h1Nz5eeDhbEsnS/2cM/nilZcKL7But516iZJiQPN4ka51lImZeGJgOJWWhz?=
 =?us-ascii?Q?NaKu2j3bCNlyTjFrXZ5+CxeUwu7+a99Pet6I4I26T8dTAkhVo8g1fr7BcG7j?=
 =?us-ascii?Q?Yh6PiGfvtrwS9p+yvXjH024rMq47rAZpdBSAmyK/EhqJAFrqUV97WgMHyxsP?=
 =?us-ascii?Q?8syg+TYnryqTW0Hoq2Aet9cRZkMSpKjzritiwKIp7V6Jt8Fk77C/wa6xLKER?=
 =?us-ascii?Q?JSoqqB5etjdJ1IuDdalA+7Wa6jJO3Z/B5JxLLSahWcRN4nrJ6/slV8v+c2Wz?=
 =?us-ascii?Q?CpEG914cvYwnESKA302ZrVANRAP7RDCLZWOW81wUlmLhVYZglM8S9GRKMBlz?=
 =?us-ascii?Q?iYBH7vZdRBzw5XrX1shfT/xG89nmVx52uTIH0hc77xsqg1SaTU4cl0+egWLU?=
 =?us-ascii?Q?FIfdTOKCeScnDm4ZgQADDKQxg51iOf0iDSuHcBDlBDOBXiHNJruKsTTzbXZ7?=
 =?us-ascii?Q?pS9cIUVQr1G6W5DVw6RHXfA7ZcdpOKEGhVYm/6XUivtmFwTuqjmZJOE8osEB?=
 =?us-ascii?Q?nh7RXiyp3pUJWwrEwxMIxgFaPNHxHYFkKfOVgcZDuvso0hQFIWBN+shE2TaS?=
 =?us-ascii?Q?wJdsWEz678o3ek3nKGSUYVfovZFD1EeLzhcMrOFnhTp7m5hCf/RzNpacF9ok?=
 =?us-ascii?Q?G5PJwtBra8llETtvQgsuojgG0ElMANUL9Qk9yRIqMtycLXyIvR2rGhGA8bUy?=
 =?us-ascii?Q?rduT1J0+xSm/nnZbNRhkc2N9AMGfsMGyHjysAJDVI0LwhMfm7aV6b3rWzgkW?=
 =?us-ascii?Q?RrldaZpaNniI2JaevbdEmVX25CmCzd/jmQ+ekhnpvA7fgDIPah5FjZhczT3o?=
 =?us-ascii?Q?uDN5OJnkk53lStse5JfslDiDRE7r76ZieUezut22cN9PbAjDkszCwLy+Ewk4?=
 =?us-ascii?Q?3mod0CFiZlOWxSEryfako4n8fifEfntwNnJ5GIH5WVpaJYw3AlVhgXMMVmP6?=
 =?us-ascii?Q?OeZhiaaEwpBbcyRxcdzEM6cwoixgrmqcA1SlHGl9+c9dWwzUdcWYnPCSx/jS?=
 =?us-ascii?Q?GgARtS6oyDDKGAouSE7/gMjXwxOrXPO0Z8gIQs51OZ1WKk0avRc55xihsjwd?=
 =?us-ascii?Q?bWqGrsg0qMQC67eAcZx11Enqyxdx92yrERT0SQO13VY/6H3+ai3MRsBoPUqB?=
 =?us-ascii?Q?iP8YWp/dfyBOCeGbwyYOJ+eoH2roDlyNxC9+c/2ftHGJdqpy4coIlecqH4UD?=
 =?us-ascii?Q?R1wPXHhmEtfkRyE8Jjwe9XEiiBgV/fcu+hBLZA7UFskSEwAXB4PuX8E5U5FW?=
 =?us-ascii?Q?12+/iFPbIsV5iqeVE2KxPgNIkpai9P8E8GCVwZ+32YC1Eoh2gabqm6edrfBF?=
 =?us-ascii?Q?wx5IL55/43JpgafDgdhX8BR5oqeHWi0GwOravybIJTS1TLvDKOHOChg+7HIa?=
 =?us-ascii?Q?AU7ssdOcwA49tL2Qo2j8w+UEOKwFglq0k/vjeK0m0FKAEfeyWceDrBsfisbo?=
 =?us-ascii?Q?4/O1Fdn21JXjJQx63uWLio3L8dd6v+34FNjAbSIEMHIEGTqBYQRw1OjeGI43?=
 =?us-ascii?Q?cBiQc2LO/RfLP4OBcSiq9LpLFU5lQ/POA67MnXogtb6Z9gperoTgMRm6Nan1?=
 =?us-ascii?Q?JZ1raw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LjCRTNxd1KGugFIiaawG2fAe9yPEOlGQhZ3t+fDLhC9O1A7xhRJOXABcivH36oPLNqhzu7+F0v2ep7rApOIxY+omh1cUw9EPVxhAAzh7q8UJOtT909qUMpVPi1eDbBMvbz4HsjAVOvz7UMDLeWzjWQM8bdwxTQYVuOT+D4gHqBfjwsuh7gv0Z8wm4rYeSIpjEkD71FAjDMmgSWniL2ktAReODATKlNsUx1vX+8I9OEO7Go1Xwa2pVifikC9/NUvKwib4LEyK2n3FNHVnst5OYB+uwHhxrN5dHi3IzN6wPNmtYdFEW9Q3ipqq/yA5K1j0nA1yvZrByEGa+JwmVXIXZHJh9aGYxnlyEBo1IU2u2TOveD9aJcNwqxc2CuAuzwnmHXepD8/6SwE9FuJ0eWaxz0b3ISOKh+wvFHTYP6FrqSQLosCd0Su33ydoHse9hh9f
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:11:13.1207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a79a6d-39fd-4799-44b0-08de67a206ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308
X-Rspamd-Queue-Id: 3411F20002
X-Stat-Signature: 73nukoeeq6u3o8w4a7yo66whkyn4wcx3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770617478-597864
X-HE-Meta: U2FsdGVkX1+VPaC5uX7jkFKjhQMh5TTUUAMFXSHqsP9Yv9ob92FrIWUbHt5JY6TeQZro7fKuHTYaTDGsRlisgqXULqec0gnwGJII0w6aN3u+Ucq6+pL2Jw5Qf5EO0knLjRWAaXuh5LlKhZQjdRAm6Aoy4Ze69GT8mlk4PS95fTgiOVGXD/BjjaGT0YAeCVRpGFWzLsZ8o9VyGOry0kxiomNslJwz2DCPDhIawTmBvedTNPakQT0wF9hypYncbgK/JJjbvzmtMkRUzn3L2cbGBRy1dmXQSLIRrUAjuN5+dokxpWawRkiTPwYhDnzEbgmEyoTKRrxrTUmN6efvH0U+0bMKcKVDg4jCQqn7zts2EPVPrBHvsNqptrAxTTgsrQdxY641Xla4L0LMZpM+anS8rT3WNladVJBmqfXmgd9b9GD/h+heelNju7fnIk8bTnzzItv1ex8kv191w1CYHlv8tS7MskvaT++muO5Aw26zLr7XkHR5W2smxkcGZtxZzQjedH9C9lFkDjfzPOVTXqOHEs1HHuQQu92wfJqW2w/+vuo/B3uDGct8NairloltBKHS+FyAUIKhGgP6AVHXIKsj/PU0hlkIg93iaE5GqnT0CC9ju++dgdYsTMbK19vKr4Fj5rr18dxNg61cwdKy5DfwKD3nfaqzDFEfy+4Ve0FWuH9mHPiREfuGj7eXA0+69gKgbWotaNEloAT2LDQ6O8VOJR0FS9XOQYg4MnB2/naSNcT2ZXSW3nxOnlZV/t4zr1pyqGQ1zQ3fr6hKmeiQ715GT0Oj0mRZ0PIlSp6wIYmX26Hg12Hq13ndAtQiuBrpQB4mOMO8PDJymdmos4h1302ei3gU0rGgFGqxh6CLCZDrjgpJavrECxxZ5CxU5L0w46M9SYAsSYrlGQiMUzZBJUrGmlug6TwHDQWpbtEZcIlJ/F+AXDuWEVSePEMmhbdtQbLlVE61VtgKGvZgUguGmFO
 FgdBi3t/
 MBEN4JVQLrOxEOc+mbw2l0I6P1l8hGBN/As4ss1OOmhvP0jrauhgIjauamQt7HO59Z/sVv7elaxBZS1fYsTStabXCkRwBgLos9aSmeJQfF9BAkFpWwyY/DwKHoD6MHogcJ6Q/BXf/OBHtdDvPyClUJ9Db6XJCp0NxlTwhszrcUAN9lrNsPB67sn6Q/Cj4QErEPjlmYmYzMAnZbYv1mooBTuMDaekHaXSp9+pEuRNnQElSVDjZBhizWsgIAI0ITCJBlUjU015Lk6QGQI7wCqCDs+tBcTPBFHPLPY5CLHnV7yDM810v4iu8JcZ5HplT/A0AlpcJaTcj0bxmPOm+PHudnLd8OwBzFyuMSYXHZGGnlOWEVcA+tYdZ/leii3Z1XtY3SsLn7KgiZzQkiSbV+zIIJfQ/6lmm0u3Qc5b8a6jTadekQNzXRkcRAfkAV8hHXxsKLBpd4LC1Gy8HGkD9NfclTGeRd20KuvAjJg7wIZiaI6gT5ps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Add interval tree support for efficient lookup of affected userptr
ranges during MMU notifier callbacks.

add:
- Include linux/interval_tree.h
- discard_invalid_ranges() function that uses interval tree to
  identify and mark ranges affected by a given invalidation event

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index a32b46355..6fe4ed22c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -25,6 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
+#include <linux/interval_tree.h>
 #include <drm/ttm/ttm_tt.h>
 
 #include <drm/drm_exec.h>
@@ -1122,6 +1123,26 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	return ret;
 }
 
+static bool discard_invalid_ranges(struct kgd_mem *mem,
+				unsigned long inv_start, unsigned long inv_end)
+{
+	struct interval_tree_node *node;
+	struct user_range_info *range_info;
+	bool any_invalid = false;
+
+	for (node = interval_tree_iter_first(&mem->user_ranges_itree, inv_start, inv_end - 1);
+		 node;
+		 node = interval_tree_iter_next(node, inv_start, inv_end - 1)) {
+		range_info = container_of(node, struct user_range_info, it_node);
+
+		range_info->valid = false;
+		any_invalid = true;
+		pr_debug("Range [0x%llx-0x%llx) marked invalid\n",
+			 range_info->start, range_info->start + range_info->size);
+	}
+	return any_invalid;
+}
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
-- 
2.34.1


