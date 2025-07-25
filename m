Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A27C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5496B0092; Fri, 25 Jul 2025 04:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D246B0093; Fri, 25 Jul 2025 04:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BF76B0095; Fri, 25 Jul 2025 04:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDB416B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:30:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A32DE133D43
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:31 +0000 (UTC)
X-FDA: 83702115462.17.586B99D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B6EB40009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Def8zS/7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=naBcpC8P;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFEesmQ6Kykfdu34NYAjd/JLU8BkhS5/zF5o0dpeobw=;
	b=6UEx4mD+UVvNnnZ0tGzbhLqTRYiMFMDXwPrsb2L5QvKcqtS+B4LG/iGlEkNuf2ciVJZIxL
	aCNNR5VWuMxQhXXGRSZr3CYu83jce6xcLUN1hL+h1Nc/dWFZ+yDF3D6yyNyLZbSYCo2IeU
	ml5xOJuZNeYrFWinNbRBbcH2f6EWzcE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753432228; a=rsa-sha256;
	cv=pass;
	b=v8O9IPXA+2fFMpaZBhIPbzQPapgsz+qoA9RPVYdVcJu/LsfukhIuHTY3mhspkntDLEkuXd
	bphGD5CoRfbpJIB6VcaFLqq9diZWYXz2q55jO8vIcJa1XEeYwPwaN5SE1ffWbiXPPzUJTF
	xLorl4pGiEBanke3GrGcxuMMdJMRD2I=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Def8zS/7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=naBcpC8P;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7g6EM015858;
	Fri, 25 Jul 2025 08:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aFEesmQ6Kykfdu34NYAjd/JLU8BkhS5/zF5o0dpeobw=; b=
	Def8zS/7ejy7WhtYNDjwyM7GNKdX2J/feT5SZg5ioyhNG53vOuTn42eQUK0MqaV1
	+cy3pTKZ0yc9UsIZgH6glugxXFV8HYxSQMAhtU2yBfzsRYalUpPLFUFI1IJcz/PN
	Iu4mdC+nfCcnjqGrYSzwClf0NtoVQlmRHh/FETlNip9D9MkNKtLwgfERvYRhNDTE
	WRqRta+a11lHFX2BYXqXemt9L/DDY4kHyJxQMDgTp7+nCDL0CEFUpf1iBiXMUNNa
	0ZbaTq9hRd63j42VS/Aqwi+0Zi8gFJntYcvFn1xqshMDIRokgGIg6UpyxgKACn/Q
	cFVDpBRDkglCVWQpeoz1Mw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h0kr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P78FJh037696;
	Fri, 25 Jul 2025 08:30:22 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcv8ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y5oprPkAVzkGhsm3huqOYj//4eYcF5LGo43DD8EGVJlVhdrwoaYmhRcsNquJJSG3xpn/zkG9voN4r8ppXpt4CV3WpslbUGjHT2ImdR03oLeX9Ps5mPTR1X8Uij0nSioXkepbzv2WUzOo7WXzxRY4xX/XvE8jCO5yD+XTjE6I1lTiErE9mGwU81Z4aKrIXCXvDk2LG872NVHfvphZHyVdAh4sN2trf20mEnst+UjYlFiyur7PHTARmxr57TXOACGZ8I1Q8/WWfLTi3LeAowUSWIGM9mznbVykOe6uHud/IT9MlPdthzWQBrjhzbhoTMZjzZxA6ZouS+zvjDIeTqlN0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFEesmQ6Kykfdu34NYAjd/JLU8BkhS5/zF5o0dpeobw=;
 b=TNIb0zUZCJu/t7z4IJ5aM0BPkxPllbXodqCseE0i3HgVAJCsIW3kureyqc8Qm8nUSyQNBMdJuGe0Q+fZu7HmLZ+oWYnMbRU1nfJjGo21qGcsvO5q1XzJO4Y3uN64W55VOPpUK2QQ9kVU45cD6V35kpMjKqs+NRiATvZiGoeSEev8oFLZAOeanjQfTMWj74gl8kdAFcMqWddKph3+vIP1Ao64eb37QSU5za9HTmzp/RYmknAcikd778BOtb7MX539SgCE8Pw4WSNekDqNIyCRDO/e+9aAgya9hhEKyceZmtjLwIjRngHjqtqvg9++ZfUjAl4dU/uea9v0zFWmpQDZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFEesmQ6Kykfdu34NYAjd/JLU8BkhS5/zF5o0dpeobw=;
 b=naBcpC8PnCsNvY2j9zJTd3dmBggb2iq3DG45BXPD74HCYFAi9uJLBy9xCV8p7Y0X/OkfCvnqDmGdfpuvQqT8W8j0UBWq4m93CxLcx/+KqfpKAv2JtR3W3KQI2xxAAE3wbd8WGoqWCyskx/u+8pP7yi12ZTuD9+d1Xees2RXGzcA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 08:30:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 08:30:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: [PATCH v4 3/5] mm/mseal: small cleanups
Date: Fri, 25 Jul 2025 09:29:43 +0100
Message-ID: <98cf28d04583d632a6eb698e9ad23733bb6af26b.1753431105.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0025.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 365d4411-ed45-44e3-a92d-08ddcb557e16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OfXv4nDzQEuxboP5zrduXk1NjBOMJT3Ht3pgxEyRhdLEobBTDhCpkaYLduk/?=
 =?us-ascii?Q?PfaUjaV6AZmHqW09cxZsuesUw2tidCD/7K690CkWGNZyrB5pHHXAk448ylPO?=
 =?us-ascii?Q?DvpYbp77wHNWssvpkClI8s9wIownpQtAItX12swI6EjR/B5iUgOSzdfikEHw?=
 =?us-ascii?Q?wcZXdq01GTC8pgN/uoEWBpEg/J3ryr0A4XYWSIflD0fD5J5jkgFrivpfu7+6?=
 =?us-ascii?Q?haPaxclclhgMnQBPyAwNR3w2I8UInZDUePdCbZL0Gu/YOwV3VozBZ4qgczUY?=
 =?us-ascii?Q?2LDDrVxYWw8xzMxqxY17zQfJUK9bNzWyTPRFgELkPpVSctoVLLG3boorgKIH?=
 =?us-ascii?Q?8pHm4k85XrABvWogAzNTwRg2cQfbecZQTCroArkD+841jV2UZM/iWQ1e5bfW?=
 =?us-ascii?Q?HSSpqeDtMQyoaZNx6mmqMfK1FhkNM8S0+mDPHIAOBJroeGhkankyeTtV/az7?=
 =?us-ascii?Q?Ul2ldSlxfG1kLvH7rCOv44FRSMh/Q8E/vs25Y83uHcUTHLL/Gp6VUwG3sfZe?=
 =?us-ascii?Q?FkZo39kQfAg4N9vb95EI9jYEFnhBFjxi1bpr5IPcRV6AjfylKXtxtUeuGTwM?=
 =?us-ascii?Q?h+S1m19mXp10a7us5+i6Aj4sKcN8BsEftJHNkLTVIYEjks3NLVAkk+CNbmNw?=
 =?us-ascii?Q?SgZ8/0hj4qM+XB84jwuNhj7z0JE6OkcZPe4Llhr1+SvKdA0uA643z0S/jqR+?=
 =?us-ascii?Q?LmbmmOplsS9ET84LOw/7A/xXWdzlECLC2rnAh2ShwMGv92xhLM34whi/MRe1?=
 =?us-ascii?Q?t+2GmV1k7FJzdakfAirTuwvWW21XGJnp4meTX196St1zoPvsVlRCJpY/u/NY?=
 =?us-ascii?Q?xXQCQXlIx9OhydWRnKKyh8qkWgBJro/KzOdyfIWzX3fhinU7NBg8lPhh3M6S?=
 =?us-ascii?Q?Wz20Zqr2WLnzhjpu/MW7NQEQccoJeeSwqC0oKTRq7IJDm0A8jfkefcTUomKB?=
 =?us-ascii?Q?il5058QALfaQkZ99RfMqSF/ZkyC6rapr1kGT5tyVIritD/2l6Dq7rpIP9alS?=
 =?us-ascii?Q?N8eRcdaqF0E2BfEaZNFa5Wga5ykfEBX63VJ6yxqD9UmMSFSVr0Zr63/KBtce?=
 =?us-ascii?Q?MoufyS/ZrI1z6xDzi4puqLT70fRm3wRRLqOqAtk9zQjJTTlye+oGST9Q/NsR?=
 =?us-ascii?Q?yOyAEhcXOA8Fc08UYRodYuFfFywefpFy6Tlu4Yxvv2gAUPvRSFER7NLjxwqO?=
 =?us-ascii?Q?is0FkHFocQBN7bSXJ6+B9EtYOzGihT89FzAyy592g6We+IbjSCZ/uo/eKsbt?=
 =?us-ascii?Q?tottwArMs1LHYptl3zo5vb1vv6l1LmiocxkBkSeXbZ4rc6Js/ez6ikiJCXsg?=
 =?us-ascii?Q?LsM1jkYKp+pXPmF8oG2dRN+T7rBxKJmUjRNRI3mO/iDzsIowH2DqpPbrMx7E?=
 =?us-ascii?Q?ABsQ4laR7/RIrkc51wj3LU48HxAFCH8O/rgbrSbML7EsVPr3g2MVSGpoS5Jv?=
 =?us-ascii?Q?MRfkFKvyD1g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ey+gxI7KK6J8YP5EzErMRFhWWZvNrHXO9vB8+m6FbR88Ylbb5UHcfe5RgJGS?=
 =?us-ascii?Q?IdJJB1nPKYOOow5+Q1sihNGz0x08vfW93iBtJnS8d4/4LyLMBZgYIlbjHW+D?=
 =?us-ascii?Q?6Q6DHENx+Jnhrff4IdMzCN6QIQOwHW8BZkL6jXTyXiRnvCmkX/LZSMuSjaNJ?=
 =?us-ascii?Q?HVCkLpXKS2C5k810f9MUeSLXzAI3e7O8NgwiAx7ZYk8SX9/vta0ZgyavTA2x?=
 =?us-ascii?Q?QPZewalanJNyUyK5FdjUHdDIxGVjLnX2Y+Y7petOSIUl7CQlq7uO0874K+Kp?=
 =?us-ascii?Q?eaO6WsCQhGtnSYkVTT3fVUIgcNOR+H+jPeYeivpdUH0UgVVQIPwEXEJBpn5r?=
 =?us-ascii?Q?yLWZzd/UUOB9fzrYuCexQ37macJUYPQdk7YgLihmkPkFjgHCj/Eoa6hUnbd2?=
 =?us-ascii?Q?i4mf44X/aMxvbttAMtp+i021Urr/FaA0P3Z5RjfLa0PfgoGG99r935bMbzai?=
 =?us-ascii?Q?YKdWlzkzz9/PT2/rpXyb1bUBHbqLYZQp7L79Gyy8ThebZRyIA3KmYZMVMmcG?=
 =?us-ascii?Q?/nf1xjeMGuMB58tHO5/CTD1cDjDWDcFDYbI48PR2VnJTDEBYXh5oni1tj9Gr?=
 =?us-ascii?Q?UM2EOeA96USmt3ZneWUN4IJopTHPIgueJaR7kd9gdHsXHP3swqCvQgX65Z7B?=
 =?us-ascii?Q?flJ4VmCwn/R5oEEG/DwZM/So8TejQ6CO/r7w0kV5l9JJHZU52NWLlOj4W+Vs?=
 =?us-ascii?Q?XNHdkF/fCCeQE2iEGQVB+C25Vb/orZWTTo5adVLGA2UOL7ZSN+lOETUz0klY?=
 =?us-ascii?Q?Kl5ushuFZISrkws+WXxNprU9L4XAhYh4sLUUTUCosLGg75CUdTzN9hDDQcc6?=
 =?us-ascii?Q?Epf39tgUhUxqkxUT9oGvp203xzQmgEy7tJQOW9stcFFI6/87oEPJ/LprSIYF?=
 =?us-ascii?Q?0TRZSF0wXw0TZXIeJ9hGFM7cj89kozLEuyNuAb+Dz3sXYrP49SltjuLeDFdQ?=
 =?us-ascii?Q?/HfBwpeugZCZ0MZ8vHfRAgzWLEJbYpnNRyzB66BZtP46iJ16y6tTG9PA0dwP?=
 =?us-ascii?Q?VbyGKmf/njzAg3LGyZy4B5Gu7nkdnBhTJa6dpbbclFW6TVlRgfNBkWqnEmor?=
 =?us-ascii?Q?bWjeNWKETlcYdlU77qjCBrklrBemh7CmBJHXupNnBoTgDZLPSzygunkC7MwL?=
 =?us-ascii?Q?2MqbvdO29erNtySHckaV0K6fLSmw2gWcRTTaRr0TrLWX/h7QhiuNMt5x8SDW?=
 =?us-ascii?Q?XvxYaKjUKQTnZASt78QYuPHMD9F4pWbpSQuBukhjn1Fh4JMBDfw/0Za1ISUt?=
 =?us-ascii?Q?5OJxm1MeO7RgL2ti2fR1a1jO/gA2WRSrtZqYluXmHJWh2wfuabC8M6MenKQN?=
 =?us-ascii?Q?4RUJjRYTAnmsfS0I6IwWJ4oJ8//oVEbg0Z2+6ji39Yr6n7XYgY7uUjljCzLj?=
 =?us-ascii?Q?mdAwQNmbyHofsnbAp6hETKRjyLlh02DywDwUUzHK0YdooS66eUI6i8ZxmGKp?=
 =?us-ascii?Q?RVVcpB85i7nqxXOyBVxMR6WZPLwmr8POVv5eIWGoH+SgAZ2snjfaMHVIKeiT?=
 =?us-ascii?Q?Su8D9l/zRvFZaLaUImIlxWclgeAlE/UpJV3xjED/LNJhf9RMq5s0NFWxu646?=
 =?us-ascii?Q?U+qWBqS9tGn5EMZvLHmdbciJi5NmSDWgd7AMpVgiN3Ei8seLFyLziKaGUC3V?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TkjmOxRIqsDzFvkh+ITzSM0JIJUmIj9hUjOw1UIOk8C5ahRwYjVwlJeBC7R53kz64GWxIAsMLEySvU3xYm9tTYWVe4UATu004m5HBKZopMRIpEjuFqhU6kkS9Yel2LZ4QSbFqm54e7UKRfTJf555rLowVPeNtQ+godesci2Q2gloxh3+3nuKfOmcpl1/Ts30h7tP2rhiBl2pA3HmRfmZ3FdsPsTeyRahLaUYqnRHHE7dS+kEiPOU9x5JRp3hM2XzNSHfgOc4qtBj3ooaTd/dDZaQqIrojYJqO/cpvr8FzsCPwdGuXrzlbJu/WRpGyckRAh/nZt1uBlKJ23+UXp/IDiPiQVPqScpAzwzDXMbONtJO3YBCyBnxd5iuFmI0wgCN3/WTcJwpO+pz8zRODqKNOAqqJvqpsyfFw8qf1JWGuHRRPKnf7k8sWBtaMLJP/6Al/Wuwgq1KsQM+c9FO5zYbMVSb+Bel4JmzYY+0gn5CU+ekZcr97jLJpPl/12s7B4k6bEcabvBe3jg0ozCA6s+lFhaWlgctuyC7XPuKi8n+cjyGXHbwg5KXn35KdujlDugznAnFZOWLDUhwuMCZc0t5h+wVtHwyWwtLAy09KYU53IE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365d4411-ed45-44e3-a92d-08ddcb557e16
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 08:30:20.5181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gfSs4ryp1RVaZTO32zQzB1u4yHkLfu8TQAY6ZkUpj41tmH/zV2M5AATghcJzcVm18vyhN7EtJWsTOq8DsOgRFS+uW0G8xm7NrS2dvakRdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250071
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA3MiBTYWx0ZWRfX/jtZtedz5d0D
 reILMEWVcbBKtxOibyHp3ywDh0/qBL+NZpVsWmAx17V8IBfYLI4R3u0fDRL5T9buP14if1v2ktb
 zaEizKdooEmiP70LFDEIx99HSEDJBT4CAZ5PVk6wzq4DBIjllp6RMs+nnt7tNNFt67CJJnS41J0
 8M1LMVNTmGKE+K5kL3hPcCezseNKAA15pWl+GFcn2bNNJNPItAuFGzVaAYZRz3Z7oYReCAs/DIf
 cYbkOwer6Tonf+QdALrYGdiOq7g4ca3kfSMcDGZNW03I+fqGAlrd6tuo56ZrWvrmujmRDAT8aWK
 k6DWGfe9cB7TQWSqYBhZPLzGwW+N23NAIzVPCo1rL7mNEGv1yCuQW6lHPTLSWtBCcQWKUhPYP0b
 CxsOMKTsFdPTSzVFi5rscpJHhqNs8R7C+sjLFYRyT00Cx2rDkWbnwwssh2xDqFq+x8Dibpx+
X-Proofpoint-GUID: SM0F0iQ9guUYynQL9ySdrJ_F25cd4s4E
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=6883409f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=cm27Pg_UAAAA:8 a=m8tF4krmssD7b1Yu0uMA:9 cc=ntf
 awl=host:12062
X-Proofpoint-ORIG-GUID: SM0F0iQ9guUYynQL9ySdrJ_F25cd4s4E
X-Rspamd-Queue-Id: 7B6EB40009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 87c7tkf3as6jtnjnnx5e5od4snupsqpb
X-HE-Tag: 1753432228-393059
X-HE-Meta: U2FsdGVkX18RNCA+1x3ucp2mXnRcp27+Ip3FFFp2sT5YR/RYXb/fhmxV8o5LKNcuo19SmJnSKlEMY/maI1CWfzrZDNHpbPUDmePUBaw6ga62QVpO+ySrVDIIyz8g8dfCw3bneF0qJPIhdPkuPz/oBi/bwbrVd+bApYSxYxup//WdDUwtaliBDz21e+l71CjhQ0RX7e5XsS84GqfiHH5+Tac3MJavmTA9fXAbCjut8q0l5a877AEkQkNuXt2ilHYqKmofKLAeApL9P9zt8XJIgwQ8mxYyYYJrOPKPRwnPn5aSfIoajJMmUgNv7sdx+dXyF+2ziItJAOcB+dbHIs4hP0CddHw+MUAM81BvYuFJLoA7itlblQ0jSJzn6cpgPpFoQriH9LONuznMnrQ9o1DYd7KQdNccUyKBHKL2htwch0CJP+08mZM+JcqWHEfXzRdzcQHDRiZD32FLXsbRrcNOyALd4tEGe+haTYWLhxsOgZaDufHK3ulE39dc1OrYo33gBZXqO/B/gxE6m/U9rcfpCUY6KXWbPahWbkPRnMuc9JJL767VUdPgHNXvEvDLm+WcMCYjjDhh/7LvCR3zq/xW06FPqyP0jWZzUFj0dvvggcSCLXtOZ9OJ2d4w9dCp4ttBEio7cdSTSNuG/D2/0wHekI6xcfTsZ+2+yr2t0mo9pXmUEAaCVjzOjC2Hl8XsNVNngu3UP5oM2E4ir+hEVLjExIkD69gB4Ze/x288EnpsWf1KlWUoKrcyfd0kbULCIdHzUaMWU63WnzKjDAsYtlK237vS9I7fu9WKIOBxzKrQiJRGJA3TlwGlHmKPNHhXM6F/f2xJnOFuAqzh2IREYaKoBzHFui+JKA6l2lKtJCyflUJC4tjnx5VASwALOBaeFGNsWtC0pIZN6Ev9P5um73gGGUqsyXW8jHI3xv2HccfrSjhaTgs2VEuXeZ/5EGe0Xkfj6bJJb+FvL9L2qec3ikT
 3SKtxPKK
 07kw+q7OgECHl956edlEZ++Qq/XYrCXjVpqGznQCvaNHzK+5Srzf5xY1++IPL0CC1rL+xkPAdlnCc0m3LCbzq7yZ8edKizPdzurngf+veSlarUXMohMuOKKOntg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop the wholly unnecessary set_vma_sealed() helper(), which is used only
once, and place VMA_ITERATOR() declarations in the correct place.

Retain vma_is_sealed(), and use it instead of the confusingly named
can_modify_vma(), so it's abundantly clear what's being tested, rather
then a nebulous sense of 'can the VMA be modified'.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>
---
 mm/madvise.c  |  2 +-
 mm/mprotect.c |  2 +-
 mm/mremap.c   |  2 +-
 mm/mseal.c    |  9 +--------
 mm/vma.c      |  4 ++--
 mm/vma.h      | 20 ++------------------
 6 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 7f9af2dbd044..35ed4ab0d7c5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1287,7 +1287,7 @@ static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
 	struct vm_area_struct *vma = madv_behavior->vma;
 
 	/* If the VMA isn't sealed we're good. */
-	if (can_modify_vma(vma))
+	if (!vma_is_sealed(vma))
 		return true;
 
 	/* For a sealed VMA, we only care about discard operations. */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2ddd37b2f462..78bded7acf79 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -766,7 +766,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	unsigned long charged = 0;
 	int error;
 
-	if (!can_modify_vma(vma))
+	if (vma_is_sealed(vma))
 		return -EPERM;
 
 	if (newflags == oldflags) {
diff --git a/mm/mremap.c b/mm/mremap.c
index e15cf2e444c7..ac39845e9718 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1651,7 +1651,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EFAULT;
 
 	/* If mseal()'d, mremap() is prohibited. */
-	if (!can_modify_vma(vma))
+	if (vma_is_sealed(vma))
 		return -EPERM;
 
 	/* Align to hugetlb page size, if required. */
diff --git a/mm/mseal.c b/mm/mseal.c
index 1308e88ab184..adbcc65e9660 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -15,11 +15,6 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static inline void set_vma_sealed(struct vm_area_struct *vma)
-{
-	vm_flags_set(vma, VM_SEALED);
-}
-
 static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		struct vm_area_struct **prev, unsigned long start,
 		unsigned long end, vm_flags_t newflags)
@@ -36,7 +31,7 @@ static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto out;
 	}
 
-	set_vma_sealed(vma);
+	vm_flags_set(vma, VM_SEALED);
 out:
 	*prev = vma;
 	return ret;
@@ -53,7 +48,6 @@ static int check_mm_seal(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma;
 	unsigned long nstart = start;
-
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	/* going through each vma to check. */
@@ -78,7 +72,6 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
 {
 	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
-
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	vma = vma_iter_load(&vmi);
diff --git a/mm/vma.c b/mm/vma.c
index fc502b741dcf..75fd2759964b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1351,7 +1351,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		}
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
-		if (!can_modify_vma(vms->vma)) {
+		if (vma_is_sealed(vms->vma)) {
 			error = -EPERM;
 			goto start_split_failed;
 		}
@@ -1371,7 +1371,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 	for_each_vma_range(*(vms->vmi), next, vms->end) {
 		long nrpages;
 
-		if (!can_modify_vma(next)) {
+		if (vma_is_sealed(next)) {
 			error = -EPERM;
 			goto modify_vma_failed;
 		}
diff --git a/mm/vma.h b/mm/vma.h
index 85db5e880fcc..b123a9cdedb0 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -559,31 +559,15 @@ struct vm_area_struct *vma_iter_next_rewind(struct vma_iterator *vmi,
 }
 
 #ifdef CONFIG_64BIT
-
 static inline bool vma_is_sealed(struct vm_area_struct *vma)
 {
 	return (vma->vm_flags & VM_SEALED);
 }
-
-/*
- * check if a vma is sealed for modification.
- * return true, if modification is allowed.
- */
-static inline bool can_modify_vma(struct vm_area_struct *vma)
-{
-	if (unlikely(vma_is_sealed(vma)))
-		return false;
-
-	return true;
-}
-
 #else
-
-static inline bool can_modify_vma(struct vm_area_struct *vma)
+static inline bool vma_is_sealed(struct vm_area_struct *vma)
 {
-	return true;
+	return false;
 }
-
 #endif
 
 #if defined(CONFIG_STACK_GROWSUP)
-- 
2.50.1


