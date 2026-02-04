Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB121E9D402
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02E26B00AE; Wed,  4 Feb 2026 10:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0BA6B00AF; Wed,  4 Feb 2026 10:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B916B00B0; Wed,  4 Feb 2026 10:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C25966B00AE
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:48:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8376E1A0200
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:48:20 +0000 (UTC)
X-FDA: 84407205960.30.67569E2
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9AF821C0011
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:48:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="js8jH/w3";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770220097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tP3sVXY94xmB+vmNR+pctd7qG+SYOTls/7NWRqxgtWs=;
	b=8Z2MjEE41cPMZk1B7PXgKuuNhNCy/mmBXp6LzGwnueWaLsuoQarv6zpdL1VYploQb1GaWo
	WjR3ravWXWYs556aEUS8yMN4IsoWJmTXCUe8YcqdhAvmjOjvhGbFjlw1SWCukFzHxsiH/d
	G6NPcz0kJbEk8qMfvz8nsQHmPgF5Ho8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="js8jH/w3";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770220097; a=rsa-sha256;
	cv=pass;
	b=ZwN6iM8aTplLo52gWcvCFzfE8DONyaoxVKZ4/U14KWIKGIKGgqpqU2Wh1e2mAYLpTGa28V
	3wfqRMqDhqcWrqsuyHAqRovsAfah6/faw4cLgGmZsUtq7iohL9DLTGhGansf33xufoUFbE
	U8RUGRkKuLZpMQoGBVAIUt8xoMlnGzU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AyNklw4cnSBlDJPp+9DSoUavTEfP71aVP+L+TutbIiLrzE2kJD51BZGBnLbk5PhmX6R2W6ihyCcQ+F37vCA/QYRjW1yU5uZ7q3xi4DDW9Bp3Vl727/uSwGNWUqIvl7lgGtj7mAYUfwVax3jJnrqrgaUtvv+yimJs/CByDuDPXYNX6Gx9A7zybZndVGeS6s2ummCxrHZYLEjOxO6voPchNvv57QKKYfz4sgbNVbUhVIwIsps1loST4LkEgZXtmvi9iV5k5IfUXH3WLkGEqQWyntYpbUnY+xRVGRVSXw6rf70UIuAT0sDb+a7UeqMZPZxAMPPdwNxwtv+l8ILMhqfifg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tP3sVXY94xmB+vmNR+pctd7qG+SYOTls/7NWRqxgtWs=;
 b=ZzLlFMzGLFGJ3gX56L61hkMFIkI4BEP81I/a8zysTXe8tBH/hGRnd+99OEOJpmj0sLyeauDVSfhTFqPFAtqUZDgY0fZxew0w8BtMjYpGiYOmeSRqWiLRwDqVibue6xQArplAXbaLo2uswBrNIJB/RNHMvIAi97HOq+GfAEfXoOQBJ1Y4oYo+TOvYG8cfEFTYrRDT2JMukABcMOW7NjATj3mxdu/S2YjkJJ7WF0Fds8jAaXHsstNuuAqIhHQSG1bZrM5KVcAmWyKD0fA8xi+ZQRRj6NP1F3Yqkl0ixxhem9apuAXvajJQuX692HdK3gU8UhDybcUC4UT2pufH936WTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tP3sVXY94xmB+vmNR+pctd7qG+SYOTls/7NWRqxgtWs=;
 b=js8jH/w31pCWwuhsiKtEoVJ/LCyHV7stCAmY8JUtfdizlqZTZo9fUMzx1a7/+UfF3zS2Rv0WMAsR04yZLDs4MgD35fQ/FxcHljIclwLzbu8xqbaQ+8QS5/5Jmj4h6MuEzuOWNFgIY0f5xEKRJBv7oMoQsYWX7n+lpm5L56tIkL1P5UJ1Ou/cmIBbsZ1yptJ1EpQ0xQmJE5s5Yd2jBo7D8WBF8JefZkpFloTuJsmMiROTuGCHjfVV/6OyGcoMLS/pwZMUD5rBHVTKOawPeqaIQKvmzGaaiJ4Vor52SmjWWO+949MZirLpVva/FoLlWQd1buR819CYtUakKYVFhVdlyw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4348.namprd12.prod.outlook.com (2603:10b6:303:5f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 15:48:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 15:48:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: jiaqiyan@google.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@redhat.com, duenwen@google.com, hannes@cmpxchg.org,
 harry.yoo@oracle.com, jackmanb@google.com, jane.chu@oracle.com,
 jthoughton@google.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, nao.horiguchi@gmail.com, osalvador@suse.de,
 rientjes@google.com, rppt@kernel.org, surenb@google.com, tony.luck@intel.com,
 vbabka@suse.cz, wangkefeng.wang@huawei.com, william.roche@oracle.com,
 willy@infradead.org
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
Date: Wed, 04 Feb 2026 10:48:00 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2C382EC0-0FB7-4882-8B87-E467454178D2@nvidia.com>
In-Reply-To: <20260204152352.55606-1-boudewijn@delta-utec.com>
References: <20260202194125.2191216-1-jiaqiyan@google.com>
 <20260204152352.55606-1-boudewijn@delta-utec.com>
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4348:EE_
X-MS-Office365-Filtering-Correlation-Id: 0adc8723-9d66-48d2-19ea-08de6404cce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YzOLtGTFq1TUXXa5Ttfh1F/cAo0SGMXm8IFgiCixFpMiN2EYgG0ziuO/M2Zz?=
 =?us-ascii?Q?QaX19XcYokyJoaM0GChs6Jo0Hx9mE0IBPFti65WhwvILP07smB5KYjq2Gh3J?=
 =?us-ascii?Q?E7tnneswlEHFA7CQfxdvCfyHguW9yHzoJ6C20jIgLGw9r0z2jw9bmJlIQbUD?=
 =?us-ascii?Q?zduIpuFqxXF8OFrM/HVpFXd9Tkc7t0VxAyM2p3C7JlNsz40/kA3hE8KLnC23?=
 =?us-ascii?Q?TN/LqeZSw69TIJW+4Ut/h88ks1QfzAzdxhA6anREcl0XSgXaPUOj/u7qRZP/?=
 =?us-ascii?Q?CY34i6hoOj+131hb3k9NitqrXwNIBPY/qcRhQYcnqhm7PPjdgbXDbiUUAgy1?=
 =?us-ascii?Q?54qSvg1CK2Hd8EP+k6dAa9faunmv9gvcG2KE2br9/HccJzhqh1AcYhpLReGe?=
 =?us-ascii?Q?JdHxVxFwbKISscFbMor2+keTMFR2oH5yX8j5ivYXhCXcszIMu1mktNEOTHWd?=
 =?us-ascii?Q?A7tqb8mYnM5E3fmVUbTBIhPwGiAeHd8Eq5L1HYPiSrPfhz9OBxdw5epd3pUf?=
 =?us-ascii?Q?Azxp7hHI6G+S5kR0QG4fPDr+aE+RSjbCMnUsRNJq1Te+TPrUNyi8Wx0Flg3P?=
 =?us-ascii?Q?X621nsIWaJeHcN+vZr2QmBAiRsQbprsD2ULjivQkwXAmmdvS9HQtXok77LpM?=
 =?us-ascii?Q?oGG0JpZvYoYYTfFRb1GqcrAKXj+zgiLCau2kxy/OyuYH4s111gzy9zRDvtca?=
 =?us-ascii?Q?C6JtskATjcApZDVxnXe7veCqEYxxEjatmspf5Vf4Md2vy6MV59sCU+rT6zrR?=
 =?us-ascii?Q?2bFJtUnb5UctjpcbumrzWXPt9NucCKD/0KuuiIbgQrLv230jdb90C0XOwntr?=
 =?us-ascii?Q?XfJL0EVt9SKUIbHSqDVowzFnZhjTQbJTQ8UEA9Z0+XPmv4LxcQF13YpSDdDP?=
 =?us-ascii?Q?LrI9C3fL/EcKe9oJJui/O5pVhwwUUspuyVnh9XRu9u6RqxscLET6p9INb/o4?=
 =?us-ascii?Q?Ksa13YIxxzPu4oX3wXL1Lshga6kEai2XrnCEINrhjFbz0cTInErhbhOVeiir?=
 =?us-ascii?Q?XxepnLSOlFAbwMGwllAw6IRQeMnZut3+0geQCy1+FCI8uVzvtajFN5Ai8rfy?=
 =?us-ascii?Q?dLokSqJE+fzKpJoygiHuUzdajkE4MjCobs774516V7ntsS8P3620EhCvcQWs?=
 =?us-ascii?Q?ZU23b8ek0mKSyypqAo0DRUG3JUEq6zjNT6dcCXLvXnmke019W84s29jlVXaH?=
 =?us-ascii?Q?+WWEwkPcb5wsN0hxY1D6Bm/7PqXI2S2m6ok5CayqTkNnPkQqr2IDvjcPxeJF?=
 =?us-ascii?Q?fx6vjt4jUg4UHv7dWuaB+xHESZWgGAglWsHnG5VW8SK/heFJ7FSsYxIOkroY?=
 =?us-ascii?Q?vCPpR2BhSbGYM3jMMFGfjFXhmPAkw9f1Kz+JUv9UhfptpFgmECWAGiPBc5g+?=
 =?us-ascii?Q?dFCY8u8o2Ki7Wm99acazpPGD6WpHzqOZhanNDYNQVlRlhPOwCxoj3FWVHpdg?=
 =?us-ascii?Q?HOoEUPKgonZzaQJ2CztAeROc/YM7ZK7xGZPsDTwf/XFkMVFuYqBiUT4UxD3r?=
 =?us-ascii?Q?qyYyr2tqbB5wb33gvb2xQB/xiAJLni9PCAw68YT+LTt4lvTV+WHdT4xtponb?=
 =?us-ascii?Q?6EAJZLROs6LGrFd8oIY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DvFPt+82lgynDZQ7pjhMn98NYey6y5ffRgyV89aVSEuithzAi4m0UZsh+Ejr?=
 =?us-ascii?Q?gLfH/XKpy3U7GORKFfF8H3/tQ3VE0aDzgd94Yg1a05zbHvSZKu4nZqwKmDGh?=
 =?us-ascii?Q?GCzwCFBEOJHCBMv0tRhfYZTDlGZD5utJYsmS765xMRb4k88U7PGKf0w/BdHW?=
 =?us-ascii?Q?IHx9fblpAGjIBJuBudocum5qQHkEd2DcKo14lSF3AqOFoaVcuRwpHgLk54Ow?=
 =?us-ascii?Q?XW9eRpZT+EnlrKvbXC9EFOIlk+NnE5sITjCrBtI2oxDel9GI+KP1AcbgoILK?=
 =?us-ascii?Q?noX3tEMKmKNvHWnmAgG9KMUQ8GBoeqpg3nN1Yca2EWGhIUhzb2NsuLyoAVsA?=
 =?us-ascii?Q?xEPTWCezTTdXgdkNBunQBxAr2tkSoPSp/S18aZptRPt7EL6elAvpiqcohxed?=
 =?us-ascii?Q?DKTEN0aFHmZzvMcL+kbZQakHqaNHMp/1WykrAfVib8rQjyNChm2mpFCM49nk?=
 =?us-ascii?Q?7kIHzeN5AUH1VaEAb2kKzb4aKwOKBFFJs7txWmattq8M+atQ4icdqSrRD1JA?=
 =?us-ascii?Q?WSiM+nRkEAK48GmEoTtkpJkPh3Ss072lm6IzAMsx+hQBLQ8QB8gSeMDD9hf2?=
 =?us-ascii?Q?oDNM8pZedPqQWdiF6u2OKeLZBFmmqbOxyvStM/rDZFVEi5P0iozfrsWAiaCu?=
 =?us-ascii?Q?kYEwniwtBdJRlkJ2TBeRFoQyNjQz5tmvTxIEPPVoODrqyICVgD/mzAnvPQrt?=
 =?us-ascii?Q?W79rrX/r1yamFXQjRluCgz4pQh7H2GvccaS0rFSUJlXX9bnnA8wmSy+jA3n3?=
 =?us-ascii?Q?OiM3rDpkMpFAfm9S7gmYKb3I0yawPJr1rn34Si4vNykmdNiPZdVvBscGsiV4?=
 =?us-ascii?Q?XRwi791dGvx/87xWiTNtMfhxtiASKgGaOALS4fXRNoMH5NStc7GoyiXl6vfq?=
 =?us-ascii?Q?CkdsMJDhJtyYXlRJn0rEO+zLGuoavLWRUAYZ6h2nTzos2hfVQF6nwhP72v2K?=
 =?us-ascii?Q?GtCPPFdyWa+Rob1FVSy7K5hY6fiYdk+gyHPnEfuhcPhnr12tAIQKuBvwR2J0?=
 =?us-ascii?Q?u9DSAEOKqlBoV2Z3QqHP0SyL6tbZht5sGNkz0w2kgs/ddlLbOihbtPIiMw8R?=
 =?us-ascii?Q?a98KOD4faiGD/Rwb/cBg1fwtGOzoYn9wH8J6cmV5Gtn2dTv4nJ/lZ/xD0qTf?=
 =?us-ascii?Q?DA170G3cCWu+hFerN1lfxAm+WrJJrd6Dj7Ac3DOsjG/yTwBjudhUdWIxZztY?=
 =?us-ascii?Q?hmfWz5a1MgQO+RVKIpZU+vx+Ei6j8V2bjsVlkaxtXn9nCKfIS7owWGTUtZqI?=
 =?us-ascii?Q?SncNd+GdgknsVtIv1ozMakmSaC7pXHIwpXLPfrRCrpNNTDCLytVtvhGqKjs/?=
 =?us-ascii?Q?uuo5E4wMTDjmuszbFPnzNPgJ9Q53MpYHdIePdq1jC0eKOf6FEwO18E7YC2jR?=
 =?us-ascii?Q?W/B/atXpC1dC2gYymRaupN1Et+3o44gikbCOBJnqIEMrzDiFqwEjmXZmSHmT?=
 =?us-ascii?Q?MxU1D+8w2a6ajHpR5On9j6eW7IHhAnC8+SePE2ZCDE3V7kA/FLipr2Mmb8si?=
 =?us-ascii?Q?CrUm+9tl51NFxAc3kChtzgxTWGTZbv5Y6RyYdMUyE7WluEJXOA53HYNr0MFu?=
 =?us-ascii?Q?ezVZHaiGv58imcOSH7HJANlkm5nXE3vu66s/aK+hJoGwhSL59Po+TW6vN4HD?=
 =?us-ascii?Q?CZh+QV9eu7zsfU1cvQT6u8IL0elzZO9P6OaLc2qqbrRpfF2v2Wws1SgjxtJT?=
 =?us-ascii?Q?C5euq8WO1Nmnkzgd7NySGvte5nG/WwHvCEBJ/2pVdg2k/uLx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0adc8723-9d66-48d2-19ea-08de6404cce5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 15:48:11.4905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlCm8bGnU5lVb6gn6RtZVc+VdhVNRui3NyXaXMlq6+mZXoPUlQ6Rm3OKIRrip2cd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9AF821C0011
X-Stat-Signature: gcigear6iqxuqtexdd3hfzn85zqui4pd
X-Rspam-User: 
X-HE-Tag: 1770220097-932014
X-HE-Meta: U2FsdGVkX19tWQlYaMbL/+boORQ9F+pihysKd0qbtB6ms6dB0tYF13airfYyL4yULfAIyTWS2V9abhl5mH8RMQNmD+Jxcu0Y7YM6ipEagukrphHd5zc2RVewHBf0nBg8P1aBh1BNa20fu1WjbGu0UtyXzoQHeYWjJEDX6lkg3s86Hmzl9rcgAQ7i3HeFicjJOfF7JGwEUwyrVvOSZYToBxkdrr3qZ92oQqdot/z+9Ojz/a5y6WRjk/9OPpkOh8UXV1Yi5Z8x1xcTAWllbu8426YjUOvpLShz4O4dpI9XqQ0D2k0rs6hxtwnEVZ/qAAu1I45xg2mbJFobgjrb9MKjqBUPy0U3TwyBJC1uzoTFphcI6Xsfw6zHOVJAgaTn80/CA4MDY0wamdjnAG+6fQl5m86rKvQupphT4O9kE66O2gg602rv2ngklqGeFIYq/TkD1lDuI2SFgTQpy64m5IQSUFAv7XxbylTzbm/wN7l8qG2NG3m+Vv8QQYLm7JJecu2kY4WHUVek9JXr4XmZBJiKH97DUeT49C9wpQHKFlmFtHpJmFiPfhnjbw2y9dsoN+lZMMYnLImx1EerV7JTq5YrTPzb94Cnkw/jPKnavGBmLfU10KXXqvU3VXbd6f3AVrRyvuSFUrjskWkWZ7Cj73UuJg2sed/gu8dl/LbtGoyknJCp6WIIWtNulEma+QtcVfDgLz4lzWkEhYu9cSxYP4XRSb0wlFbSU/TtYi8DZTmz0cGmBPWNvjxoiARX/mR5ZZKk8ssRS1AijY7kTKb5tuKo8gqFeVAf++GNB3CkG4iji00rmPHyF6dsMSBOCcPKWptHVLIjBQaNtBWCazFM4LRxryR3CPbEqdWj2bdl1aBHY+22+PqAw4+JBJKNSD/DEEblPwQ4Y//FdFxoiv9sW9r4OmsQUy+O8KpJ5JTWPWqAPFBu0QvaIQ7ucoZH6eBw1HQEMb9o8esCIHdkWhdUX3H
 hrXMjw2P
 BW8iJ+zfUhaVdEzoPUNap17LrEMdKpvqG5n9xr6VOE1ZqGAgnXUBPnwnqwvdajYFGOAX8UePeHSrX8o2Y+y4ImY2OQXuPh8hD1VPELxiud4mGZijqzgSTWAfNsNrfBKkonT2gi4JURGOEKEelVfE+/Mf9gDewjlAU8P9Jga+on+Hio+RlCh7fIBhVeandqpU/ADJdY4V8niImRFytOqbKiZv80ZWzTtPm2CPusxIhASRKv6k5E9G2R9f6NZHhWgsQklCp8sX1OnQqN5bEevlU2+RU7kZs+gi6iasiSWKapdhajk1Wl9H8jsQpRUDWoksLSIdOh/LEMp3FsYuQQTIhC4Si8w2iMqulbyVj8GSCccOnhQtkv5twxm/afd6sog91lR+oAKrrkx67ciA/y91IGqxrhnjmcVr4o7R8H6JKKyJMAl+5ZC6+hhqj7eebExQjNUo8yxahPVf+rrv64vwCogkouWVeLJc2cQdDHGLO2NhYIB+5E20GxoOqUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 10:23, Boudewijn van der Heide wrote:

> Hi Jiaqi,
> Thanks for including the THP scenario.
>
>> Another similar situation is when a transparent huge page (THP)
>> is handled by MFR but splitting failed. Such THP will eventually
>> be released to buddy allocator when owning userspace processes
>> are gone, but with certain subpages having HWPoison [9].
>
> I think for failed-split THP, we need to do the following to support them:
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index cf0d526e6d41..3f727038f400 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2479,6 +2479,7 @@ int memory_failure(unsigned long pfn, int flags)
>  		if (err || new_order) {
>  			/* get folio again in case the original one is split */
>  			folio = page_folio(p);
> +			folio_set_has_hwpoisoned(folio);
>  			res = -EHWPOISON;
>  			kill_procs_now(p, pfn, flags, folio);
>  			put_page(p);
>
> We set the PG_has_hwpoison flag here again,
> because when the split partially succeeds (new_order > 0),
> page_folio(p) returns a new smaller-order folio that doesn't have the flag set.

No, split code[1] sets has_hwpoison flag when it split a folio to a non-0 order
folios. If you do not see it in your kernel code, you might need to update
your kernel to latest stable one or one newer than or equal to 6.18.


[1] https://elixir.bootlin.com/linux/v6.18/source/mm/huge_memory.c#L3343


Best Regards,
Yan, Zi

