Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0725BCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 20:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701A26B0088; Thu, 21 May 2026 16:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA0D6B0095; Thu, 21 May 2026 16:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF5B6B0096; Thu, 21 May 2026 16:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 547F16B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:21:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21C1A1C0580
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:28 +0000 (UTC)
X-FDA: 84792547056.16.AC2DC51
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023115.outbound.protection.outlook.com [52.101.72.115])
	by imf05.hostedemail.com (Postfix) with ESMTP id 536FA100006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=lnueduua.onmicrosoft.com header.s=selector2-lnueduua-onmicrosoft-com header.b=VIbSKTuL;
	spf=pass (imf05.hostedemail.com: domain of Maksym.Shcherba@lnu.edu.ua designates 52.101.72.115 as permitted sender) smtp.mailfrom=Maksym.Shcherba@lnu.edu.ua;
	dmarc=pass (policy=none) header.from=lnu.edu.ua;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779394885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aUJ0reA4G4VK7j4GC+xEsy8lfJQh34XyjnGk53bKgM=;
	b=T38EcUdNOCAs4EMBQT+8XexScyb47oT3iQ9ArZ3l9dBfoJHjRZV2wo17HcPIPkfHaH6Cmf
	tzHNykfIaw85x9f3E8Q2Ih+Auste845Z/aOyWqIy3bVUGOP0itRDWepINCjKJzMzZXyYCL
	4N+q4ECBQ8cVHqHUOe5rD5wSBBzpjH4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=lnueduua.onmicrosoft.com header.s=selector2-lnueduua-onmicrosoft-com header.b=VIbSKTuL;
	spf=pass (imf05.hostedemail.com: domain of Maksym.Shcherba@lnu.edu.ua designates 52.101.72.115 as permitted sender) smtp.mailfrom=Maksym.Shcherba@lnu.edu.ua;
	dmarc=pass (policy=none) header.from=lnu.edu.ua;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779394885; a=rsa-sha256;
	cv=fail;
	b=wexE9GpkNaoYMF9H3FrxJn794sZYhmwXL3Om02Qa+yBQiSw0f0oTS4+t5HS3j3u5SQGWs7
	xS8AKde1I5690M2+oyFrEM+SNvYZV8WzMtUcewQEnh1b3bjm/9PlmMDs5F/7swWKwjxnhq
	VffcY5v4ZZUb87qGc4pL5ImzGIH4FEI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cab37G6mfYkN0FEYwNX3Wn7IpWqqvuDYKjURZ1d54XX2iZ5auVoyT0tEYGatvdNZDtDBeEAYE7BTRPqZEveayjYOgbMuJ+lKgSHbHw9E2EDIOHClcuSmfRQdwPL8uZMRIH4/w7wySKGDHEVCBXye5giS2y187EioVfFlHlgdAK0J6Y7WWYUy+JxN/qbmMT3wlj7zmXIIqVNqoHrh8PlLhBW+ZIwZquHajshz1MWPl3Zc/Lwa6uD7kjLy8q7hb0KY2FEr9xSm9qkQWbDbekTGatlu4S+BmpMDAXa2BIGJWrU/JDbS1FhuA4sJcEOkjVTcVJ5SXI1dTpogYF3btrfjdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aUJ0reA4G4VK7j4GC+xEsy8lfJQh34XyjnGk53bKgM=;
 b=WyiPjvASpTiiOAMuLA70zW3Tj2J1MNZ1vuyMm3s/qq2KApABoq5YxhrErs5B4g+qW06Ki1hpTEtXStArC4HApq/3l2nIB/tQs/indLuZXL7W9lxSZCOQn96ZDCMfnt47rOPEy2920ZyfH4uib5IP14Y5qaJ8MyhHbund4Tft9zTrbpKpeS591dP7S/CgRwb9iqYPSyhfCLu/tkCSVmDX4+QPxGnZ74Dk2VEGXEZ4ISDfk8R4oXZnkIAmcKVEzy5WFzLUwfn6N0Z/rZzN9195ptGpQ5JUIKtenxDApDlX9LiB1VdkUCXTGRlv/O9jzwTpeyT9tsSo1kU6A+jyFqUTZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lnu.edu.ua; dmarc=pass action=none header.from=lnu.edu.ua;
 dkim=pass header.d=lnu.edu.ua; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lnueduua.onmicrosoft.com; s=selector2-lnueduua-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aUJ0reA4G4VK7j4GC+xEsy8lfJQh34XyjnGk53bKgM=;
 b=VIbSKTuL6KTTHMyTEVXmLVw8wvKcmqDqasAgt+9l7DgKv01UHEhFSqDWExiILcKDTYZ/Nfj82pF/4l7k1XJAhOPDWDISqcqoqEu+SjcA1TS+pw+TP+nq43QbLP9esg2D8gaDgkpvfwnmc4Z6ctKdNfI+eAobfDdAm4W++Kw9FqQ=
Received: from VI0P190MB2524.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:2ca::9)
 by VI1P190MB0655.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 20:21:21 +0000
Received: from VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 ([fe80::b775:39dc:b909:e5d0]) by VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 ([fe80::b775:39dc:b909:e5d0%5]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 20:21:21 +0000
From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: SeongJae Park <sj@kernel.org>
Cc: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
Date: Thu, 21 May 2026 23:20:20 +0300
Message-Id: <20260521202020.126500-3-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521202020.126500-1-maksym.shcherba@lnu.edu.ua>
References: <20260521202020.126500-1-maksym.shcherba@lnu.edu.ua>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: WA2P291CA0021.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::29) To VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:2ca::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI0P190MB2524:EE_|VI1P190MB0655:EE_
X-MS-Office365-Filtering-Correlation-Id: 861386f0-6572-4cef-2a99-08deb77685b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|786006|19092799006|7416014|376014|52116014|10062099007|56012099003|22082099003|18002099003|38350700014|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	4ElwgaFXrYCfSvE4lRHLDTQT1K+YXQfGU25V/kcLzO+OG2LalfP/jYBlQRo5xXFjUtbpQen9o8spWbXvGlWXgXoZMgHDDw0BGekrKfVU0PnU02HT5w/zmeQ7MGOYxW4k4uAtLtx0vXIzQB9evbrCOSoj/wNHDIHmOltmUiZTnp8fuIWA1DyEbiT67eHaI/RDnXQvoMhGs9pwJHJfJOrjlye2lKIYVHGwhYRjNACbxY2KrPtjT2rPfmiowp+YcrUkvpIyrNvC7MNNsxWEKT6OaRVivRCvnumzhjtSOi5FOZt/DndJfhOyydVI64MWb2+MpG92vDDDdWLKL0aeRbQ4/RwwTYUJM0ANOSPN+56M1gV83M8qpbmrRHVw4B0U3CTrdcDG73vxzqBmbh4sCQwD0+V8Sni51swKi/AM6iIWcsH5qc2+LxebUm/F0g47PSWNBjrY0KGBHmdnSnQcJDaTPGWYa6/Mj59+jkDMkiE9bvb857WQ0x1FG3CtsAbvCjDctfL/VHtMmkY6bJKLAmEcLeZiFlEzfU/l/4W+I6e1v0NbKZlGegFam1IzSE306XNn5s5fgLjqnhHqZmgAcz41QNVErx3pCB7I7utBuXGdPeDEtyYrtso+G26r9HY8hs4K84ByM5Bq0N0gvnnUwpxrFzjyeB8O29aT5wgIfpglATtnLM6XN0sJ3inkT027drQxcXc3LCh23guVQOkTxwpwVYFiFazxHnoimF3iidyJg/E47Z20tN0TvUIp8DH4y5Ls
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI0P190MB2524.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(786006)(19092799006)(7416014)(376014)(52116014)(10062099007)(56012099003)(22082099003)(18002099003)(38350700014)(3023799007)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AWn8VaEy7Tlx6l2kToYGsLkcpRu9nbq/FBq6zUA0kX8ivFOb7/XJioWWCpcZ?=
 =?us-ascii?Q?HweOTTxgWXQ4jNvsN2BJ8UG8Ats9EsirHQ0z9iaqw4k4wtZmokVvkx+N3pc8?=
 =?us-ascii?Q?6WoaU74Zr6Pnr7N8sBahvdpLND2HAK8sdYq+9ag8SaYi8vpIQx7zNweXF/4x?=
 =?us-ascii?Q?ukCORmxlTHiTxvshQw9bPCnlrsD8i7z2/4kUa4tV6YNj+Ls9vTUN+XwK1ISK?=
 =?us-ascii?Q?mmSm+nqDSf0VgOiPbPuEOuGSvmNhEs6D5XGXNujsAz2N8cWwjEFoQooK5WI/?=
 =?us-ascii?Q?jyvNoO5Ukb/sHnSbclwueIOLhl7NmkrE0pnDuxaln07IL3orldkb56rXDJzN?=
 =?us-ascii?Q?+3CjajJpLZ0w8wlytWfflNaInczAkgk1O/0CCr2/dPyqHPJr/bvNCrqC1QpG?=
 =?us-ascii?Q?Wn0PTa2GylRP9K7ha+n4eujVNOGr6lS0Iq03YS8RZGBxIK2NVwFXoGt0knpp?=
 =?us-ascii?Q?bRQ2NyYpahByyuYtfgvPxSiN/r6PonPoOUUReEPxdO34j/vbg5qK4VC7L5Nb?=
 =?us-ascii?Q?6ufLQjmOCA8wP16vsZEiJ9WUlUG2LdANU3wHDJLLH2CnzUTl3tpSWnDfsSb/?=
 =?us-ascii?Q?hrC0CShlp+JgPfgA+JhDVEXzKw/vXcvB8dcXdLnSgKG9qaaiIXfKMy3hpOic?=
 =?us-ascii?Q?MYifyL+WHC/yt7B8Qn8jYMqVfzhwcJFfLypVjNtu4tI3tKPcMXpq6A9lcWNK?=
 =?us-ascii?Q?kG8Nje/dXaztApBa4EUwiMUJDbL1vb6I+SxGLIn+OErqA32wjqnB18b6ZnQH?=
 =?us-ascii?Q?0HOu0PEWxS5B8p9cY7YG8MdEl4faKpkl7lq1EApVYd3Xd6EXWH2zj7ZZT+GR?=
 =?us-ascii?Q?W2wProN8M2kwZYHSSkzDq71Xhs0FYDpq6j9W+oXony8ytAUqewXPUmuqq+Un?=
 =?us-ascii?Q?o3Rt3QW7/s7B/WVIzRP7pFdXGyhkr2JdLhYS96j+BjZCMWF+zoC+hPrU0d/x?=
 =?us-ascii?Q?stZjnK7cDBGDZfWhgZhpNYMflPA9CbEXFw2jRgUQhuum+U78KcSGMItuZGgu?=
 =?us-ascii?Q?i9u1hbDjTg2xAB3M252A/cp9/tgg5FonVvTfZfaa9FJyqjtuJiBrK3V8gq7h?=
 =?us-ascii?Q?SU2feaE8n3eLHMBk5upgFfB74woF7P11zjdlE87k/rZMdGG2A7tA9D3lk53Y?=
 =?us-ascii?Q?xXCWzOyquHaetByvT004rOWOney5N+W02hVhNGDRh+4b92jY1t1wpAeorcoP?=
 =?us-ascii?Q?fVA24HYDNHu2IKcNXbxg+ecJM8sEJU5DGd90i6E8dR2cVjtkORntI8Yy+WVV?=
 =?us-ascii?Q?zZDE7HksiOcXLtaCSWOIBFXGZc3jSdZVx+et25urCJmhNeUfWKq03etnMavy?=
 =?us-ascii?Q?oZ12XRSMBcF6gkmP2pGfAkoFsJVHDB0l47ZCj7IWYzHo/Oai8SkXDQ6oNgIN?=
 =?us-ascii?Q?B7mQDR0qrNt1JN7LN3WdvIuKg2NygQ5EfLI4wt71K7gWm7H99bA4LAHHDxz5?=
 =?us-ascii?Q?vfdCq7+Zx4hhecnax3LHF8AxK9smlHABTARXTZvrebBHxiyXHpPMw0fW1uX/?=
 =?us-ascii?Q?/zhSGhcE2qIgTqGW4YaW9ddakGbA3DPSGUhaQ4xLoYOXgv8di4qDAHaxEpDz?=
 =?us-ascii?Q?JmQcdIpHJLCLoG3i52mmcvHEYQ78moYaRIeQkeoWUWZPFTzsFr7AQP92Yix/?=
 =?us-ascii?Q?d/br/k1KR8ddhudLVQlz5d8K6H5Y88Zfpf5Abg3jkOANW68ghLLuH0nqhyAg?=
 =?us-ascii?Q?/+JGPNnRbVUagD4RlM1dYgHq8peqWjOmpxjwaEw1l4aM/NP5cRF91/5VEaqx?=
 =?us-ascii?Q?qcX5Cv2vQWk4ui+19pMFG45JgRia1SU=3D?=
X-OriginatorOrg: lnu.edu.ua
X-MS-Exchange-CrossTenant-Network-Message-Id: 861386f0-6572-4cef-2a99-08deb77685b6
X-MS-Exchange-CrossTenant-AuthSource: VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 20:21:21.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70a28522-969b-451f-bdb2-abfea3aaa5bf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8wEtoHAEqt1t3VkI+InFayBJtjbkHz6ATR+s1xClZCWL67oFywktB0NJB7XP9hs7zOyt3k8r3ZF9xrDVsMzC3ZoRpD4CEXGWfTzAvkNGVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0655
X-Stat-Signature: 3ciku3cq5iktode8tpwo9w8icidcyqb9
X-Rspamd-Queue-Id: 536FA100006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779394885-688980
X-HE-Meta: U2FsdGVkX1/A6Nh6Wz5o0GTn3AgtcmRNufrosb5+YhwL0QtOCQ3WzCUslIbKvyKn62NJLF33XUo2ti4RksNgw+pp7rL895TW9t7Luj3teZCeCoEhH09dbEQqOhbwS48u2muy7j5TaRBe/W5yet2yAr2UIwYsKYU2euDVwXoGAtzg2XqY76tJ8ACfElAY2YmA5TpXsnQ6okhNmkBphdnHZdgxXXRcXFwfJdgW/K91Yvl5vui4NqvagXmcE+KUuAjY90JLNisGlMzXnswFc1WK1q090/1T2Dt9V/6mSRi1GKHO90mqwI3GNOMj0joDRwIoNE999uhWjEEqy/PW+Qn3h6zAUkbW64D9JAG8+S9QsUfavQ9uGkV3ixETW2eUOnK5p5dvC8r9E1IwBAUne+hKaY//fzBYeqe2JZX00T2tFMOuwM/ag1qstAOspE0EomfdRHBEU21j2ymjAgT25kzepMyD3SCfKDraniK7DClP8y0X/vyaTjdjjLkLbBZLTEfqVtdA6mJMSNzF9QZnC1axv+/OdJ/jbED8tOUw9NHeQtoNUPJI+bom/TI4X7PoUk7VksiQRb0icgOFCP1s8VuQVJ5oUcUhcygEaCW4+rhrYZcf3DZefwv4H0qxEc4GrzRc1fR2a86YwqTcsLVvL3AyfxziZCAJP+3OQplcoE6TT8aTNliP2/j6QDEljLqKWXO2/YUJpvrLZgOPHbhirngKXGHfXessPQ0u07eT80nA6QMwTGDvyb1iYb11Gp7V9DtN4MxXLPxSWXvlejwpW2cMrujO0gkScFuqu3uqvtJGvO8CwFUGT02zSRnnlw+OaJpzcNdFx1Z4hHvPT4wl3I3tTvcwLNkd8RrxDUsw+76DjKmQ/qhASniB3smtOE23PAjWLxUsM6O6ljhmnT6fHWrfompKVL6vkXs23xiuj+Z7llazeOWAzVdM90yvquFh6S0zuIouJWV8hBzxOh5XlSF
 FwCy5WYZ
 xfArT63SfcGqlLPP+9+zetqL5xLFADEXe2AaJhbPJLpLImYe6RVV0Ns5/nNrJ/nfed8PuvHOLVOkXY+wR2nmc/W89AK1xPFALKRQxpDhPKAyjuzzh0D3Qk6WCWEeqqAX8XVuTGTXKfsdSp/PNDJuSh3aDWTv+PmO3fSz4uqE9aFs3WG/yVkDCWd0o5uG6uxskr89GjWjxeQy0ZN2fBwb7frhIgMI5zpQ8UBMOANdIvOXoF/ki5rj9QUx2PR5xO0W/srjldozrfN6g2s9l5mCW/xv6T4vfYv8g3JgAG1b52kFO/kqK+ebVjTdX1xKEJiKI5SRYm63PCKtxwO2HzOVe0rOquAAq0aNzCFR70avpzR4iBUxXe22dAm9F1ITXKugs3EJ0LSlLlQTnDrZUt9icutO3MGsP6Bg81h0IzWeJqAyl+CXtR2I8PRf6PhWm3mHk3LI1xkS6JyyfqVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs interface for DAMON quota goals includes a `current_value` file.
This file is not updated by the kernel and only serves to receive user
input.

Clarify in the documentation that the kernel does not update
`current_value`, and that reading it only has meaning when `target_metric`
is set to `user_input`.

While at it, fix missing commas in the goal files list.

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index e3e2ccab218a..5b85a7a2ddf0 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -511,10 +511,12 @@ to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
 Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value`` ``nid`` and ``path``.  Users can set and
+``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
 get the five parameters for the quota auto-tuning goals that specified on the
 :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Note that users should further write
+reading from each of the files.  Because the kernel does not update
+``current_value``, reading it only makes sense when ``target_metric`` is
+``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
 
-- 
2.34.1

