Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D03EFCBB6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB166B0129; Mon, 16 Mar 2026 02:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5855F6B012B; Mon, 16 Mar 2026 02:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433AB6B012C; Mon, 16 Mar 2026 02:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 329A26B0129
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:20:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4502C388A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:20:22 +0000 (UTC)
X-FDA: 84550926684.23.4E77BD5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43C76140006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:20:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="X/Wvjyqn";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kay5Xa2m;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wg5ynyYY5d4MUOnln6fzl4AFLX92TqaBYM00wPJ0Ws=;
	b=A+67ATgYO+gv0/scbR2YlnowMSqYaMjn8i3/odefx/Qqfd10NR6It6Mb+JNHn3wDJNcTzi
	h1Vm5RaUYd3VFXpzK8lwzhDZy+O9Ds63myw1rEJr0yly2wZ5lDxt1POWs2N45JdomuA15z
	YRAT+a+Z6//+84Q4sBJoxVnmjWVT0us=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773642019; a=rsa-sha256;
	cv=pass;
	b=OyVYBScOJuqEUN97NLueSBn2aD3fUcaecxpjcoyghCNKK+gUQyE8vetZbMYyySQVzRVqiN
	yw7boYf0wioPJWfKsP8bLxGJQbYfojCVBgG6jp1HBszbiuS4TxE4+//YIC43qJguQwkGz8
	W+YtaYVAFv1VjQ6C/AK3jbGl62UIrkM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="X/Wvjyqn";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kay5Xa2m;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMDwWA729985;
	Mon, 16 Mar 2026 06:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8wg5ynyYY5d4MUOnln
	6fzl4AFLX92TqaBYM00wPJ0Ws=; b=X/WvjyqngjEfsDB5UGH3hMFzCjHo6D1BfX
	Lk1rc6plu/yRELgtPY9GotFeGw9Xam+NpErB844fMXxVrTp2wHrE6imBN05JhHVq
	hL8rlSeQcrCHM3iYa/MADhG2KSTIVb2lNbE4eAzpKMRmNxVhHL9lbJfce+6dEUwC
	+lkHroqGQj+DQmD5ixGiSDBzxCuMYOJU3h1sA1JmzzwgOFbk/A+vLJkBZOZ2dQIl
	OSvkWC1hXV5Byf30ihsbhHhnOJXfF3y3fUGF/STEHQB3LV7NOXEL3fKIBuqTervJ
	qXq+pon4Ab85EKaUPFiN+30f9wxWecai+uSTNpLWezUBPYBNyMJw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxk89m44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 06:20:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G3Ac0e017960;
	Mon, 16 Mar 2026 06:20:05 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012062.outbound.protection.outlook.com [52.101.48.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4jpk8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 06:20:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TnH9Ybf07a5CCcP9vZRi55+NLaybbVNcyrnfKP0vuvXL/naWXKwIdvTqkVtC/vORiATtyCeO+QZbHjOmZD+Juu+0YY7D6cAqUe62qId/nNxdYOO06J4AX1hFEdcg41HiDfU29t/gW3re0St4yR1cRu3O6LTs0NJSSOkm8bg9Tr0DG+izhbgLD+KWNnYkKe1qXEOzywyw2Sp9ld+evXNm55J4O0uJlk/srlmeEnmttrr+AfqEblBTzIr4xOTcwzWV5pwZSmj/egJcBtJc0gpNYKKJdysdH635g8p6a08rAXw9TeWMikwRUfK4/ULK0xhTB8w7KcQ9BLZ89RUMkcwExw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wg5ynyYY5d4MUOnln6fzl4AFLX92TqaBYM00wPJ0Ws=;
 b=NtHWci0S4bmjkuZaopB7MQquq4QW41a4Ha5+jjzft/ixpCfd4iI+N6aBJvg+x7cyxQKfXJfNJ0hCjDVZ+MQPiw88IkiAsZTW731QPGdQnru0XgPIT5+PuI0KS/KQPLaI1iArafKO1ApCshOvyz0bnU93p6pD5/qls0cl8PLAAs6/BLtdT+5ykyx9P6LT7FXA9+/i5CcjlTleC1TR5F6Rb5sJVkLKhaA6oFb+smDBYPJzMTE84cKZ9hTRi8SENu6tF5YBrO5qrxWHuREMmF4psO5EWB7fhsdfMTM0ykqpvwt5KZOwatn0tVUiqMKtzEA+uF57aNhr4iE9SOB9BImZgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wg5ynyYY5d4MUOnln6fzl4AFLX92TqaBYM00wPJ0Ws=;
 b=kay5Xa2mxyPlh8Xtlaqr9XDiw4StgM4iIH3dWgEYBakMQsPlFHtnCEFsFE71Ypx0HeZCAJKNnBWFd0vbOl65f3s+LT8y4hwbhcc9MkYUvCNM/V7s7jo965Lm9aXw4NQOpajsgs61lgOmQzJB8BUXPmsmwTjJBohVhWWBWHeyJ88=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB7169.namprd10.prod.outlook.com (2603:10b6:930:70::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 16 Mar
 2026 06:19:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.022; Mon, 16 Mar 2026
 06:19:59 +0000
Date: Mon, 16 Mar 2026 15:19:49 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ljs@kernel.org, riel@surriel.com, syzkaller-bugs@googlegroups.com,
        vbabka@kernel.org, peterx@redhat.com, rppt@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in folio_add_new_anon_rmap
Message-ID: <abehBY7QakYF9bK4@hyeyoo>
References: <69b703e6.050a0220.248e02.0101.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b703e6.050a0220.248e02.0101.GAE@google.com>
X-ClientProxiedBy: SEWP216CA0015.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB7169:EE_
X-MS-Office365-Filtering-Correlation-Id: 67eeb74b-7f49-4f46-3edc-08de83240cd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2jZ9SldHEMvzrhnFGsA65nGJXeIHs4g23xP2mhkKN0CfjpctRN0p2PP6gMnApYH2FccN+IhCsMxftQWmSYiFO22co/73X3Edrb1LdNuiecU/55ER3UCsC6sovP6ve4G/KDZoFuEF1lmLN/3OUOnwny4LqBibJE9x8Rl4BUpvd100MgRDX7vvhJ9jNfSn/R10apl5ofkxjw7Zj0aMZDqaVQ79FQ5qDgsvauSPeFOq4GI+ghyvMMA1uWiUPguu1wG94RCAyxHYHtMrilLg51rue6fjhiySTN/mMEGYPkNHmTwTaFR2+4agLbLn4aMq4aaopCnyIT03t0c/lhc9AW0y5K28lhqzN1QCFm0Z6Y72QWeRzIlD/V/kHM00vKtZh7StDi64aRDcgDBZm/huihAN6FLa5k4hHpgL+N2+HJjSX4bFLpVFiEue/2+D5WtP/omsILJ3mK/T13FS8ukELzgJBlCD5PzieKD3p36XdSz8coh6rxy1vouqc1enkCu8j441SshdS49x9bFgwL+ezEdGpjvesCA/spJg1ohh+icB0TeJejZUpikbMP0RuKqklOcrKiqOMvNXvF5gd87boGVnDfliau1+7FWAOneJjY9XfIfMjEudWcR7Os/BDt+tfwzUqTt2b1qKG4Owaxc8qMfebG+rEq2DftlkxGGkbIhVFJm8FrI40ZBPEHcMDe7t3jZDFbIlc1PHeU+wIidQc4Elh/eOchX55WMdiUec1HDHNww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lYpv/nkEN7c3WLvHQwqMUJxaGVbbeqiJ2JgMpQW7oONJZZ0ydD38M7CyweWp?=
 =?us-ascii?Q?1s2+JFefZldSlIa2eo6qF32OeHWpgGIc6cQF0eRxN6GYyJniS9khBzBm0esO?=
 =?us-ascii?Q?n9E3dnVzJS1j6RvsnUh2ZXJJGVQwaGsxqaqf8tc600RYdgdoQYR7SyhRkSLj?=
 =?us-ascii?Q?8vKdSH6z9kF70rIHqmfHal0+JNTK+n5St6gHavYE/zTSxWiIkhbh09so8SUf?=
 =?us-ascii?Q?ZhBlVM5DqAiSnis5cTUxhTBK5b6RuTfBIKq8wYxMMey4du8dvQnHlv39OyFW?=
 =?us-ascii?Q?VkDYL6VSumiJAgJKAAY2hHET94X9A4y5CbePGNRiBXP0r67g6DSzMCKD73xC?=
 =?us-ascii?Q?BKOzkYQD9EcVAOR0NdceRb2LQI9DX9ga1fnufGGZ430VJ1y0vJ+wEf4rQip7?=
 =?us-ascii?Q?A3vQcsBc9KklX76OSDM+TSq/RQOXeoG+VgS/03LCudc8LbsQrnMVcQwA7CP5?=
 =?us-ascii?Q?hrTHaq/WugNaJqzEoA6YSgwqXOHBtU2ftgPEUn4Kp5de6FYrlbIo9aSPt9av?=
 =?us-ascii?Q?nQjLeH/8l8gxSXz6/+R//nQGEp83/7BlUm/DvDiVuWWR0F5AQrM7aVKUOHpI?=
 =?us-ascii?Q?eCxj59Eph9if9ugvbhDr6oy0YkF7UMeSFRQQE3/iLcGoQi2I1Qi8Ljaojn0p?=
 =?us-ascii?Q?pdsM7OdoWZs+aK8epirZecM8ujoIpeTOxkoH9oujxmwuz01dVilsN6ZTBlyB?=
 =?us-ascii?Q?j8Qj1QLPZnDDlXTmojityTkpe2acBEokMvKpjNRd2IRQY4/tXIi+v9ajTk6H?=
 =?us-ascii?Q?MCed8quZNu3EyrzDDGtqr1sarBtMMSnB7++82MK9sihzjp/gAd6wlrNJeDgs?=
 =?us-ascii?Q?iwMHNelRdZSkZfuYNt6BUtBnIPJii7crtujelDR2FSPTKC0RWADC6Ijw00ZH?=
 =?us-ascii?Q?/tN5CaH4dmuCtvPBtHj5gMvMjYezqeGzDDE58or9HW+YDwPYLCZ5nRSFZGd2?=
 =?us-ascii?Q?GmOBY9RqXRVJDoldlcQEzVZXZjwvzXZbO8n5ZI3I4vELhSK4Czj2yULjCF9x?=
 =?us-ascii?Q?BYFAPJF+1lV/zRHOImHw2VkF96PNDdQNgWlW5NLPkqok50A2VeEezOJn6++M?=
 =?us-ascii?Q?ujZTd2oKGP9HNzXu9LtJcTl/YANY+v99R5N5GgIxaJ71nXv18SpR95RaDkKd?=
 =?us-ascii?Q?M//xrOHSqpXFq8ZDIx3G9mXTH7Pf2r8/BzqRLFZ9dCOagBk4p8M6s6hFnSpE?=
 =?us-ascii?Q?FJIvqMnxy/c+qzmsUUfwsK4OGPPDGWT432dW8NN0Awu+m8kJmDSJxkgosjMD?=
 =?us-ascii?Q?0MKNu+qVCTI4Bvezz52KQpsRxi7MuIqT0JN+43yEDq0X89k2Sw3gCARCWdwr?=
 =?us-ascii?Q?WCTc1kDWiibZ/nG77rtEMcRCOpsqyQjRgJi+Bq4S6Saj7uXEGnyiCs+VgPiK?=
 =?us-ascii?Q?uf/kLGaxmy73YtUYeibMC3KK5ee1y5hsOK14tghI9yw8Oaq4W5w6YbSU7PKB?=
 =?us-ascii?Q?sWDbFMHBuTmfHr7z50VDF9Vl3i82kH9oO/OrlnhP0Pg4W1Dzmea6Az3oTIi0?=
 =?us-ascii?Q?G3b0oSjBuzXzhM28gk1JCf27OLe3dNRHzTmXuEAf0/RcR3R0/4izRbxI9MRA?=
 =?us-ascii?Q?5GxRlfDe85tTOc3qjlPyO3OlKMBllMiUoinM871LbpGmEAhcxVCA2udJKtup?=
 =?us-ascii?Q?j5HQYcfkbi+y5EBzXMe2F27EPkNqpPNPX0t8qm/WqoXXOhTJv7/IDG4i4tL0?=
 =?us-ascii?Q?p0qOqhF3mggbxuUJpPPEbMkGr60GDwhj+XTbRdfm+PCOujxlvwzhdaCS5CNi?=
 =?us-ascii?Q?90DjMxBT5g=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	NqS1NHRKqfOd2qCfzEJE87nyNZ1yEe4QcX5Wi2sqiYuCV3Bc38LeQnL7ZX8i9CDz6DRUlGQSQ8frqnDA1UcXOmcZz++FSVaxoeZpg84Gu6EaArOs16wIpIBrogVjd656I8Fu2OgX1ioDBsJiorllST5pGDMndXlkYxVMPJXMimsbeE9iCYBEftmO46g/qtptCGJ6FFJOYUGpvOBtyM4KhsUoMwDF5P07oxDoHmQ40sJZvwXwB6TY9I1VAJElvjrlNYj9QFnAI/YQ8JvkbYD193lvFqkd3hYNSHZ01jlCZQi8oKZt1e6MHDhurLHSFFg3mmfiTyoNutwUyO/e8u/Xog==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bZYEWmhRuNSss5r16gBNFoeBX8jxZWRS/RV3xsmhxIHaC8eCo7hZrOQY8jCfS+JPG1RQaNjm8ISsZn/10cT3cmjh85MW1btypSsDbp3yqcHc2LfEjlTuqIzN6dUdzmdyHBzFEtAKuIpS2VH0YBnMOg6TUwd/ROkHyQiQLrqUepBW2cy1UCKYOAVXcPGMOg+KqB6sLawy/ZRwHxkUjwYHByPX0+HaH+UuSbdINdVPrfqDF155cItJhW+BBU/cCxJE91TURGg911eKXsW8TKy2pnNPNBHUi8f9NOJwT3aP/kZ1lJbXwz0IKlKLrZ29m/NFFMl+0YrKghe+xetWLsgSjrgWRk/ozaY0lu9nB9r7m2fW7xDWcedKaDDz8TepSyMc0Jb5/Hh96cZyVtWGKeXfqbjgJBnu4JHX1qaCkGw9B26EjBebhjYn3RaFQ0Wb5n/cVM+evHMBT3Aw99bZOP2Jbzwq9YePU7AOSZuiEMHk4WKCshiB6PebBxXuAN4BOh8Dw8CSj5dYtoS7xuXrEK+6GkhLPg39Fw+0l+JK6ryS/uKS5m3kRIKy4eWmB/l2d5nDysykhRm76xp9Cv65OaOShSarNEFAzhxghlo0SeXOXg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67eeb74b-7f49-4f46-3edc-08de83240cd5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 06:19:59.2894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+TS7BhO81ijz1DfNNgErbT7U40tvDjP8VRMt8nr8icFJcwYafUMfqyozm0FJxkM1PAGgVEwTHtwtDkV9An9JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=879
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603160046
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA0NiBTYWx0ZWRfX1QnY1JPJ+9u0
 s+/+HQ82SAIfB4pRZTLZKGqQQJLwnFRRwWyKLn6PWx7fe3TAAipLQhMwgilDC1+BJulnwuWCr81
 MR+sreLmTnZw9NMiyP9p3SbevPWA9YJY6krzQdp/9pGgtdA+vM6T0aH/d66TZOchJ7+wFBpzQhF
 Q++e/8Z2lIuOrmhjOl350tZXUQn7wUNySstJLCvdQ0WyIDOzPJV9lt9an0NUyJQefA9IPPW85pw
 PMJAdjMzSWDZzI98wsY/7+cz9XkckeIMT7k9cptI9sO3aEAL1W9tl1pe9xyluCAvIfZzDYxFthc
 ah5XrNc3CrxpVucv4Jp3skbcRLPGRzkr+lyLQmjZDUZ3vuDvHfaLXo4602j7/VmRuOGFjsiinK0
 w9SQLpr1aSOYuHwt0mTI7U1gMY3lYIvoSNXPNLfwjQdrSHu0T5i1ZvOUxr0zSo0OHqWPVvtEQya
 IgVgNqWec3NLu9dBs/em7lh/6kd9Hv9dRFGJHOVo=
X-Authority-Analysis: v=2.4 cv=AI0/m/Lt c=1 sm=1 tr=0 ts=69b7a116 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=ckdtgYxvsbnrLUn3tW0A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12272
X-Proofpoint-GUID: mvwtS8T5zl1Vz47faASiyb_80At_dqTh
X-Proofpoint-ORIG-GUID: mvwtS8T5zl1Vz47faASiyb_80At_dqTh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 43C76140006
X-Stat-Signature: g9gi7jc7fno3nno7y4iy3g5gkygzd1ka
X-Rspam-User: 
X-HE-Tag: 1773642019-109441
X-HE-Meta: U2FsdGVkX19LYIywHYceczzrW7LvVpq/DQQbnUVLwBpcMY/Zsji8deMMi+3kbDSvbVrT/hTBIXXlYPTHPU94p+1h9T1O4VHiTWe+GNrvr/jlf9q89AOlqciJr3iO+xPfsAXLoDug97nlqorNC9zXgc32hrR3fnjfKLe5FW4rUJjpmeTXX58/pG9q+kOsnOaJ4k6Xi7IDwKzJH2YCR3V0Cy29K+49FM3ZNGFSAPHxgafhOsIFAOx9N4zIYYTEp9kbmjhjb3AP8E3O3vE7TKqbRBaPq7WFl6v7jK9f5jmbxZkh9ipTskXcEjeSR6OBMMXgyhL8TQfMKM3r8XpY3VE6Etk8qz9UvVdv2z/jaOqkyEquBMNuyncloXvh7Rt7CpgodivZtAoXbLvX9GhrStP3vbVsWJ6pSpwHWtqRw6oxRuQYZ1TxCYDE2Fuq6hfXhQ0g4ywNAKOuF2c+0gEwyVAbigfz9F9ABPOx41D99lu229UR1oVyHMVlbaXrTaSp5Fxx0PJlPx/hU+bUpLgH72FW5Ebvqw/594EAIRXfLykIrdpRz6V3c+5lWvbdE8jAi7xTtiKVrhjwjcLwzCqt9mCixpLyznh+AiiCE8Z/sUU4RMjCY7CPdyfuBYJpthFuMDhDxvU98t6DD1DgRpHkOq7Tan4JFiWyrotWjb7mFmezNVaJjmiUMFTkQMPUCpQXjdgbxsK6ePLmNDi+BhoXoB2hEm0mESP9kf2gqQb8of5Ecd4Nj/IT4TklxrcdDtEEM5gz9B1SmNUV9iML0hgi2pcVlGcJOAAiar4ANbk2rEUwbG5xNCj9UPSsbgqXgHb53/yqRUnNvY27f8D6oVO9+HaqgwOW3cyIvH0F1O1RU8rioT8YJyjNHnPBQK3gdom+KlIXTYRw+Q3cowYnxIB9+NH+RyFoIejLD56Q0sT2HSiYSsn5TuvJs+RBgaPO9VkfO0nGBOkE1gfP/8jpSLcQiZC
 2j8f5BzM
 g8K9EcIcY8xSJ8bJWtD1HRJzAkf+s+B8B+t+hKtGQ7fp/e0lhVa6+g+FXXdOAT6zI6vEcL9HnO/gpYnO7ioFtOn8mjwhly9KUCpGaPkPJ4qGBeWT+WssP74OH6b8ClDMUqfdj86s5wGhKpFTWgDT2sOWrxqJicGWgzTNvaLH1h3Ca8l5oVR/VH7VJ/ZAhC/Ose/E7lbpt+wJV+MPlhzLD7CvwkZMcctUb58QT7193sOPElDw/pTfzMVHsgBg1j+7XBfwrRWl40SDFV8SEb2e4ghdo9mPveVUOFZqJDJvkkZUiMqRe6tuhOairsvfVglDEJ/LUCDsEHT3j6degyo2YHXHDg0nKd142Y+mA+TNcBHSANlOw1CZSmLZrpWhIQHyuikT9IMn4qDFs5IErvaI6ZTr9JRHj3PphSrvj5za41l4Xm3ReRMO4Sfrl4knDDjUqR0uEU1Uhk/4Mayg9cdPUAS5eeEFUtQvUqzJSiLq/ioAD6ITezQGavcMQNW97aozUECoj/R5Jsxf+MaUgo23KwtjD9IOALDnZNDH+nHrgNMWlKnx2NPlHj5EHuTrsnl3lxZSH4m/F116T8WWJm54yEQJnsloF7MowpAyl+zO2j4lSURnughiB24h3E/9NtO/dhv2g3gigyqDX3AWSeqMBobBmqPREwe3dzv9gRJOQzL/aExhZUphagf0YDkNvzWzI3BBV5yj2xAaPiAhXZ7D0lvOE+OMi+IZJHRFfbBsb5F4PcoaykbSlUhtjK8JF0vB4K3egqd0sriCy0DSSOjuy2giOpMdQtJgoVBoOm9iJ0zVsgumIAMC5eZT7isYB1+tvqSYYD7wviEzZGRyhk+ibbaOnAu2DnphyHg3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 510c6dcb9824..73adf9ffcac2 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -880,7 +880,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		.dst_start = dst_start,
 		.src_start = src_start,
 		.flags = flags,
-
+		.len = len,
 		.src_addr = src_start,
 		.dst_addr = dst_start,
 	};


