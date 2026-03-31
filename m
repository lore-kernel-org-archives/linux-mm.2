Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56D4FF60CE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 06:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27DC6B008C; Tue, 31 Mar 2026 02:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF926B0095; Tue, 31 Mar 2026 02:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15036B0096; Tue, 31 Mar 2026 02:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3E9F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:35:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46DD58C701
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:02 +0000 (UTC)
X-FDA: 84605395644.16.8B9B297
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	by imf07.hostedemail.com (Postfix) with ESMTP id 846374000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:34:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dr7g1lRL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.24 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774938899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TwuGlbxb8jF3C9KPlhXK6dlU1ccfq5AkyJgn52OVw98=;
	b=pNNrpew5Py19psZvlWE7BAXi/DpQvpSz/HcMm5ZSJus2gtJVvyBKeo1vfFo+9e8Q6j7YN0
	w2EOu5Ly12Ak4PFTnDlbGDd9QxoEQh/kERFgGIUC8JR3l+isa6Q8dE1Qa0u2Aat4Q/CHo3
	P2Xy/F+YpC2l7Jm0rucLVA99eDSdeaw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774938899; a=rsa-sha256;
	cv=pass;
	b=B/V1+jWRYVr+4pMYPxY7HrmHeqzz3l0u52gfxHiZwIMK1oAdBjyXW7NvEv2muRxqd0h3qE
	34dBxc3rJeW8k6APQlofJoe07CwSHzstBcRhiFqyKZP95xAz9C9gIpbsP1L4SyVcI0PdWk
	MpeoSfxMmKCJDg0jKYKujdR2lOdOhHI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dr7g1lRL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.24 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfDAmQzdgBk1AiZeunQqOQmPK8bGxuEFOqNntG6gx1H5GuyCKONFfbqJHoN6Ghl0XhINrJnItUFNdWqcLhIq31TriSxJC1YYL1zDSaDDfe/qovuu7W0UvvtwqZbMa5YH8nTjk//m/wg4MK/On63Q3XAc05BrufNYAf2/IAnNMG6J0RPB9hS/ltsuIDRJBsDf+6D5QDcISKYMzoRElg4QcRSsbhKz6RRZW0PPS56WMub2V8VfzqlQzV1nnDr4S42fJIFoTxKK7xvWAlN2xssaIp4wTY0Dh/sWI8/iTEpZsVsF75JudtLPKbbudgBikuStTCsHu0d3gWh+LK6CrCCwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwuGlbxb8jF3C9KPlhXK6dlU1ccfq5AkyJgn52OVw98=;
 b=M58Gu228sUs0vvEZjinlw9ijAK50gdDWDFjbfyyoM21NsIJqTp8YY+XEYv11p/B2Ua7OmueW3N7kYwnyk1GhoYw6QAJj8Co7jt2A2vU7e2CNHQHi0Kw5DEFN5m54s6abOuqaqhlNw4pY1/A6zDXNwdDk/4wpgTtYFmA3pn5mKcLyi33bdhLXULOhSK0lqb0x7GOkvNup7o2xqz0Kkx8QzwTdCnlNRz+CJrO/fjWjyaCHN9o0/xlJWtoBYbbO2ciDoqlMQLzQ+lCcq+hAY6wDRbOhBRjZItr60X+1bruxxGE27nfwwqNX1PE7sI9t0rW/5/ED2vGsomkirJuYjTK+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwuGlbxb8jF3C9KPlhXK6dlU1ccfq5AkyJgn52OVw98=;
 b=Dr7g1lRLoMK54TPy892OAeKShpGdDrENDeico1lY4/grfML32MORKPIcDbZ3cEQU20AnRUN4vZW+BNmK5U5pflGw7NBsH+O8zTQ0b+QiacklPZ9mj263qpwUeHoE0HBsfZH0kYcYHZ6vtWPDSmTO0zc9TL8SrW2x1cjBulMTeVm50IGen7RDVu5d46yi9IEWYNYYGt6wji7oXd138pKMICmDtWW5GLoLwcDaWOicNlypKDgPgRSiZzuzDS0nhLYaJKp7TTYTwLpktd+Uknh2FvXMZzfNsZBjT7khOYJ57qCft4VDPBA4ypmLgkn/ff4YfBpHasSZBtdawdu+3l+L5A==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 06:34:53 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 06:34:53 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org
Cc: zenghui.yu@linux.dev,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	dri-devel@lists.freedesktop.org,
	balbirs@nvidia.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 0/3] Minor hmm_test fixes and cleanups
Date: Tue, 31 Mar 2026 17:34:42 +1100
Message-ID: <20260331063445.3551404-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0089.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:201::19) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aadabf2-5d10-4fa5-1088-08de8eef9dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	+qiqJH5FDpJCe4d0KuZjCTWXsZ/waTKW64ynsbSlFcnemhnNNT5ZAOuGdsCVA2KbBUq4pwNDxgxloNuyroqlnMWQOvha1HKhEqJXU8xL+PGnz0Iw0Bib/UCs8wz7RydNLVNUK7muvlCl6K5Pj46WgwiQPP9ff77N7IceOGwvR64lKS5lxqZugjDK1FPs+HIP+j1CXqYDI55UvIUsGiJJINmgTeS0jYRpCfspBpIpZuM++CE2B9yofa9zgjbRZ/afKTPa5/d7l7eb/yo5y015dgGxGaUwPF0oY0ILd/TSr2QEyZbBBpaZywXR8wT2MeDirK9R7nAfUQIG7Pq2XPHvcs7EoL4IN49uerQGJ6pfnCcrzFa4g86Ydc0KC++Gq/fBMW7CEWYJD0vCnM0P1idyhjhIi7Er1QD86FKjlSb8IjHve8+KPunqPIY9wlmNPC50f4cFso0GhtjhXggcpN6wZNm+n5QEKfBN03X5GxiF4S4TERrR381AvQaqFHHit73ATeGoQnCxp4nBMGB8r7cU15OSs26+ZTDW33Wbqj6zuaudB2Q6Vc6z4eDkhaCSzBIx0DCQTWUogEQWYIVLt1ndp9v7gEJhhUivJzTvjDqA6zxeAzRQR2DJfFk6RPvkPIekabpfOW2sx6JqwhXRY92HKmRTkwGu6aNth4vZvgNRJP1UlkAhd1faFLLh4c/6WcIEm/w5sFC5dNth8lLM27d5H9E83Yi58eLasEgcWJTqoh4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?10bcZN93iJCmjjz5oCHUbiR6WnMYweQdq35QYgALWLllR+cLSppE+GYb1chH?=
 =?us-ascii?Q?E5je/cQJ5f3J1upzOwrevjtikqjEtyfmHNMfe5NCk+pRpmElOIZXgcZOY+L5?=
 =?us-ascii?Q?R61KPFe71MfnDbI2Kmy++HbXbVWj3a4bp5rpZyOXbp1gzz1QNZ3lCLe0zoPo?=
 =?us-ascii?Q?yJWxhXuJwe1fP0x8vq4rql3XRj90WQ01sCz2hJF/tZIqFebW6jJMRauy+GFP?=
 =?us-ascii?Q?NnhS7W4NQ/XtCLHeCiuWThW+YAyn/iVo+EDOfmVIebNulglf+99I7QE0p0wR?=
 =?us-ascii?Q?at/T5GviQ44PZj+PVxhuHdBCmJBEk5F+RtWDw0SnhjkZzFtozfpHFO/xRAZk?=
 =?us-ascii?Q?U5iZ/Ahh5nHw63WEtLGrfRvZxhpDDWUd1zLAHZ8KCGjms1voL+jgZ+iC42d/?=
 =?us-ascii?Q?35l3QF1H2CLfZ30iAgtGAb03K1GXgKd+fseVnh+m2IkSFnLakwURb+MIWqOe?=
 =?us-ascii?Q?b9GuGzNRFygcWC+CrS01Wyaha1493Pfpc0U0cVlrjv7o0ipNmSuz1Q851kh9?=
 =?us-ascii?Q?yIC0XwZEmX0DcOQ3+RJCtU1BgTcT66HIk2qFdrBUSRUSq0nQQgGdxez7wSrl?=
 =?us-ascii?Q?JEj6IUJv+KCtgjwPfIxxoKJmrXiyc9MYL5adxpZxDnEb43pDi+GFrfpXX89R?=
 =?us-ascii?Q?KHH+DaBVeMi1W1urrmEKWcPEiM3H5d4Q6/SzUs/K50STNcjTSwcdlfne0vJ2?=
 =?us-ascii?Q?p9+vgHpi9ThJ8ROw0BQaWN/TBDsLm+5jHChPfdCmPgeFJxhBYFk92oPHZlE/?=
 =?us-ascii?Q?u80ymj83rT6V2PgVGUoGCCGElhefs8R+8BVRqAznauLwtfSyvwUKlC5Lb+Mh?=
 =?us-ascii?Q?ZxqwL2zN9FlxD90Kjx7dIoTYQ7GHNtqXH9ytR3XEOlltItTxs3DXowBSXtwL?=
 =?us-ascii?Q?GdElMKBEajXCp04i0Ic51ycm16ING5hnaImkL2CP4+udwoIoEfh/uaMZTpiO?=
 =?us-ascii?Q?UMjtT6GeF/JONpqNdWd/NzysIZIfavCPng22AwdFMRUJkE59LT/LuFlOBItc?=
 =?us-ascii?Q?2LfrD6A2TWTLVm4/aAY+OJ4EU8GXR5jXE/T/889lPUgxfVrQgOFwFq0hX68T?=
 =?us-ascii?Q?zaB6jeTG3JlKbhJbZjacQtErK8StHY+ajr/bQAtDi8KkULCEgacQGerM3ZPw?=
 =?us-ascii?Q?YELSBndARDcwo7iqJyngpGAiSrmizW62gNyB6Mh6oJSOcHnW8LWHE0E6kAHe?=
 =?us-ascii?Q?Ei5j/CbipcUwuvkQy4f/qrsVQ5FuzkEFROhmT63ftNFarkxjMafFkriD7plX?=
 =?us-ascii?Q?SlGAJ8AKTc42Sxa2K/qNg+wLOQFpghoCUEsJnzwQyUdVugJ3qY94S4Q986qD?=
 =?us-ascii?Q?ZhIWmFjzLO7SBCW/WgVUC2MZITmxRGmmJg2qqc6cdfFIGumTpJFCvmladT3j?=
 =?us-ascii?Q?NcBKjDE4F1AckgwPd/g7+V4uM61Tdv/A9vRA5tDUPfOJCk0ss6dq56GFJtHh?=
 =?us-ascii?Q?PukpuyYh+aUp1u9dSROBaG6AOaPnJ+6w+G7PIHD2datSNOTPQzJY9XXNrLRh?=
 =?us-ascii?Q?kXIPCMyrk3/34xAF5rkTd4uXs5I0VpQTXeAZnsSrfrBeefWfWgZ2oRrDHHXy?=
 =?us-ascii?Q?zSD7kDSzNaXiAYZnIaSQyAj/wjPpL48Llr805uEELcZe7Gb+FtkNySSk1NiP?=
 =?us-ascii?Q?CENJwm3FPFPImovgrYC0gZ6MeSjHfRf0hZ1i815746bpzPZrCGDW7LRp33hd?=
 =?us-ascii?Q?jb7SUC9WPS0pCrkNJddpuzXnoW5KJihI+WR7IYMLenZbz8u5OtyGuVvvOh9L?=
 =?us-ascii?Q?lmuQD0B0pQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aadabf2-5d10-4fa5-1088-08de8eef9dec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 06:34:53.3940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zKkFydajDinBH5Fn0WuZbpF818MDayCqPWPu8vAsZedQkIkRQhTkPLrmQhyEN7UlfZPVcFn83v5PjiunSd6XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Rspamd-Queue-Id: 846374000B
X-Stat-Signature: incryu5aweyk9i86mzfsm13de68d6rki
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774938899-227804
X-HE-Meta: U2FsdGVkX18OcZlKGcmbD0St3PjKR3Aglsa3QLYD/+AwbvDfl/piYUcMYE5sm4MIjZD3y/UlRAM1NPDpseBfqA7ZxkMJHk1a4eWOz4CZHFKqcydUXLhaUTFHEMBiH9KlhjT4+k26n+DA9ARsJmksTVNq23KWvJH1k/UjMl1Nx91GzcYXJhVZPZw5O0boXrs5pZ9i/PgT32zkSWB2dxfeFQiLNILrgvimkxR35upxGe8LfTNkSuZ8XRrpuJjlKqBQfJ/VVDVze+U1tIbTNRXhVt0KriRmZduttsWGuC6cH238wdtFGVD4SfbyRuvpJINqTaaDUzHPXthAxju/zgbBKOwH3zaWFfTt4Ab4NoAYtpTu74TBZVoxkxZMa4U4OsFt8n/6+85I1NatkQaK0ABwAWkG6grVSKj0RbCtv7+ZuPFuW8XV0ePz6F7RSc2iXlekXfcu7/eW9rfGihReLWs8/Ji5DoO2sE4A1bGeFRU33k2UPdxfOzlNC9uIAKVYP6tTuSAjO9ooQvliq0/btNe1atZcm/jmBneQA5b3+HLHBgWGEm+YECG5k3EKP0SOqhIxwtcM0jciofL8zTBBmB6TDwcoFNM071XVrxGbMD5MxnzdHFjlzriAcmigTH+n/FMr3gxJZBptcBLQhObZ4PewcjWu/YVjd6gwPcyvHzO9sO7Wl4G3/nCA8Pq0eR9mNNeVB4h2NGWd9YLMu4Ui7a0k+y3KZCkm0zR9dlkTKD3l3e9MEpeK0fCgMFMeGIe9MPxhbX1r/bUyf5BwMWRU+Wa8L4oIAcvmHTC0i9XEwUuxJTc2/gNuLe5crA6xpeqps+J3lOnZEFVHPeGBr8+Qt37PaeMb3VZQ234ASMoN9MVODak9FWyKZordpDloG81cVjDenXnHTRr3KNdI5LgVuSwrf68W+ixLWcxBXV51i0etYRJN+1AYq3l6BVViQQaCfRM545XUmoUnDbxW8dpn3tB
 +Uq9mp86
 aB3XYPqoiRzLqYecnhmiA011jKb9MepQMibqaRxK3UZ60BlUen6kSHRPNH2ilD+mkA5SMMFsNtU8oxa8Debe6EDKU4pPcqSkjFxikukpyuxeWniPSbqOtVhAAPApUibme1aimZ0hODolNWpx8yB6dY+YOfCFkcGABi9u277qQqf2wuFj8g/xVOOoSvifVc+ut8AT5E+ecfZZqVGyAaf+bEoiCOgMnHUr5dJ+FkGC6e+9yOTCkLDEECfqAEc7+nmdW8PgU545AjQmVt88/+xhWUFW8P4fM7aRzYKbqpOEKGakw0UI+Gj7JZ+PQZX/AbvytrZzx1ZcTVG88q9qOTJZEBJ93o3BKY0aGdg+ACViIeQvr/2LKV/f4dTHItTP1Lmuutz8RRK1EKSccoQ5AZ/IUSdZL14DK3xEYAFJqz6fsHHNTmSc+i2IDGU4Yqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just a couple of minor fixups and cleanups for the HMM kernel selftests. These
were mostly reported by Zenghui Yu with special thanks to Lorenzo for analysing
and pointing out the problems.

Alistair Popple (3):
  lib: test_hmm: evict device pages on file close to avoid
    use-after-free
  selftests/mm: hmm-tests: don't hardcode THP size to 2MB
  lib: test_hmm: Implement a device release method

 lib/test_hmm.c                         | 130 +++++++++++++++----------
 tools/testing/selftests/mm/hmm-tests.c |  83 +++-------------
 2 files changed, 93 insertions(+), 120 deletions(-)

-- 
2.53.0


