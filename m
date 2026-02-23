Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CE5EA4FBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E5F6B0088; Mon, 23 Feb 2026 08:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3D66B0089; Mon, 23 Feb 2026 08:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70C46B008A; Mon, 23 Feb 2026 08:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD1CD6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:33:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A5BDC0241
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:33:39 +0000 (UTC)
X-FDA: 84475813758.29.C08C0AE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3EF140012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:33:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ozuXFTnN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pAuJNNYY;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771853616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tmVwJebOmx6rypjtBvNVSMca3eF4pTK5Zz2p6XTtnPA=;
	b=ducNnxeRjuDGGin8HiAmwBaS1fCBFYk1Ro9hPEbSLsmhi1jS4qOWuzkdmIIUFsnrPVxh1n
	orkT6omuIU60XXgZ1nA/AbJFA1rSem6cEWWA8Ml89JSO5qHuFSnHzxlpUHObWf9EkN8gMP
	Lk7WBNsMiSL6L+hrvQnGIsQxvF/L3Fg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ozuXFTnN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pAuJNNYY;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771853616; a=rsa-sha256;
	cv=pass;
	b=wnIJXfH7O7lTxzsHf2sRGlZ2BobzFwpRDDQzRCezAQbIRAwW+29QPV9N3M+q7utYDoUJXR
	l2+mxZU1UZ1NzI77GEym/rnCzcsLBTxI9clvjHeRgA/5zWOnOh4XRCzaPofulnoqY0Vtaa
	KTET7aJMdEz8ghyduT1ZHSuuUWhJWPw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61N0JCnS783191;
	Mon, 23 Feb 2026 13:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=tmVwJebOmx6rypjt
	BvNVSMca3eF4pTK5Zz2p6XTtnPA=; b=ozuXFTnNPsYg8wN4i2FIqaeF3RXNPKeC
	hp40HA1UAXnNjrDXpFNKQgBPZC0L1kJw3AwEfzWmpUK8UIb1g6YdWVRUtI+Ltt7l
	DRq8bqSX7uw84pCpa4JOryV4WCjBlIR3Zz8PDHHLFvOPQuDef3+spqMG323nNeTm
	7ahvyGPDx+4hWr0fccSIXCg45FTKij68W66/DHN1Z05nthFa1fU6/vGNEHDircK1
	CErLj59C7eMjzYRuGTeGonfmlIqICy39nXNEZIhAUfH/5Z6o32fsdO+kT4lNve7p
	s6dJ91FlhrisV6zwIfkdS9UiAt/Z0q5Ka6to7NWbK06kApCyPC7eFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4ara9gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 13:33:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61NBtD8K027807;
	Mon, 23 Feb 2026 13:33:32 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35dcqmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 13:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zW15FW1ybfKWPGKsXKw/VfGP9qY3O3h9bGoJwQIP36ALHyr6FxLlAr3WihgdUc4GKMzbJEM7PmZl/CKEIH0brOF0sDx/iUq01382BADek3eUQvKh1oqMxGWxZD6TuQl12nJaizPGcLtTtcK076rI5aumphi7PDPNMGhEmVfWkIui3+DO55+3UajxfiHrr+y7JBtnzebpwJ6hzi2owJnHfvxHEqt13Qc6GcWg28GgirsbDIIBYlBihhCODM201DXm2H2bPciR/Jo+P3cvFZwkNXG8q6cS6gMU5OuhLWZlKb2RPqSZHMZl82eayNGu0gmAtOL4ZHOyEEVUXPNZ9rFCAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmVwJebOmx6rypjtBvNVSMca3eF4pTK5Zz2p6XTtnPA=;
 b=UskesCXgKcF/G3XA3mws9z56s4D7x8mifyyTB1humgGyjbvv58HhdOctYoKqFv3KReHT1iLOiE2dJrXs6GUC31vbyUrxy+bf3wstd9EPD0ayZfCZ9QX9zFEUCl0mFlDiwevOdfxY0fIi/+nM3yQMSHcGHYnjiANGNV1zMLqktQL/73t1A4TS6udBPhCS51aEUPDtP3nUt5smYJmtMemzpML7iD3WstbvGF/9NOoti40Km9e5aGnMq4FrWy3KLVomT2YkX3PhLP2g2ZRfQT6VP7sWjtzcoY33OQky26a6Q4N8fEqK8G8/xv3GM1+OghP0g2vIa86yOh0UrUi3GyVOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmVwJebOmx6rypjtBvNVSMca3eF4pTK5Zz2p6XTtnPA=;
 b=pAuJNNYYVll2E0SjwheQ5H6l67mzCPgVhxbFAHHjzHP2KapV+zOWByJUwFWEvB8OAfwQSJG5YJkrrZtWAkIPllU6yuNZL7rFsRlqn+7HbYTydtZU+MgIFYPW5GbhrINXvRayrXhNPirjz4v7mnklTNuOMzAc7F8lkg5Zlm0Kthg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4155.namprd10.prod.outlook.com (2603:10b6:5:214::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Mon, 23 Feb
 2026 13:33:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 13:33:29 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
        linux-mm@kvack.org, Chris Bainbridge <chris.bainbridge@gmail.com>
Subject: [PATCH] mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback is available
Date: Mon, 23 Feb 2026 22:33:22 +0900
Message-ID: <20260223133322.16705-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0110.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4155:EE_
X-MS-Office365-Filtering-Correlation-Id: a1afc20b-528c-4a74-ea41-08de72e02153
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sz+235xF8UT6RGF8H84+W9nuTsjkF2ezx55ZdsTNpH62UUMlfFF626YgS/kI?=
 =?us-ascii?Q?pXT5OaXHP9XAH+yUlnGh19I76SU9/CVVYYUzBE2nIwqLWHkGJXhxr5KmL0qI?=
 =?us-ascii?Q?8jhMumyfWi4WMnOTF4d8LjujRzsyfcZqU2FCypI0ri8mC5MTozhh8lpmAitF?=
 =?us-ascii?Q?N6fjwMVmddOqNdV5oNbd6B2d1Wbtx/wO7DY/kBqNb4BiOtR9NGwvZf3I/avf?=
 =?us-ascii?Q?7L6RNzX00uIQbLJtUgp3BNbcv7URKhrPzw1teN9zx9LmP5uZ0B72poaMn/8o?=
 =?us-ascii?Q?j5luMPgc0Wcxd6Snd9iO7DIvswjXEDlvZrehPbWaOgjSfH2/lhdKCOZh6FRi?=
 =?us-ascii?Q?X3PeqteSc78NYJXMiWQ4XX9bbH/LnoU4Z9Nh+xbZo6hQUlMU52AJV8NzKo6Q?=
 =?us-ascii?Q?7SvhZxNm+Uc+1aS8eW5nVp+x0ZTw5HOPsfDfZ462E8fwti02ldPTvlWKg53s?=
 =?us-ascii?Q?cSDJ+ElbzZLch9Ta37e39Yil1QvrBwa5MID6qRSDM3Th0uBMikQKjHaMATxV?=
 =?us-ascii?Q?SyXsgjdU3wsnW7bnXTcG2kSuZRDOeOpPlq+3G+W7leSs0yrFT4Ahb0fU+vUt?=
 =?us-ascii?Q?jPsbwI8mVdKEvmYp9GwwBMrtOsnOGl0yk2DTFbXBvaFV5TWOuy6jno1M5tqy?=
 =?us-ascii?Q?PTACtv2HmXlRvSH6HoSMGOHJ4FC2OBMj44kdsAP+GpMb62aj2GXZACHlDCCP?=
 =?us-ascii?Q?4lNXh/L5mP6IEt/sbq5GwstMZMUbGtX1+KwFSe0l1MYh5+igr9GCP3Qfq4Zj?=
 =?us-ascii?Q?8KC9uVeYZ1Fjgi/hoceISW7D+/YLQ2Zx1O4K7cH3JaLRC6OhPC/cWwv/h2NI?=
 =?us-ascii?Q?hn57r26myQDYMYhOjHXsFdrukmLF+/+slkrc87i8elNdcbnNhP4k9xx9LB81?=
 =?us-ascii?Q?N/iIjPRXPAu91x6yqZ3IhkUDAMctfXERKOxwU/8KiJYaYToavmgoxENBSw5X?=
 =?us-ascii?Q?fO3hLIajylZlRoISBuW0S83hKkZf7M1tl9dyclwZ01qt/CCTNiNeftTCemuw?=
 =?us-ascii?Q?zzg+D+PPuAePiIqXJ1EaPp7rj/2gLyLvH/dWScoVu/fWFgsN5olWWs7FR7yD?=
 =?us-ascii?Q?cmwnOIsaPadQ0uGpLfBYwAZ9N9X7eMGl8b5UFxWhSQuiDM4wJm9WmuViMdxw?=
 =?us-ascii?Q?JLu5f7X5WBukmkpHPu7WW1YZqFDn8aoB8omC9xfl3UC3acmeqM2EPKr+KukT?=
 =?us-ascii?Q?MaagyYOpYb2HLPHtC9tsIN4Bp+CzJ5Tdztxrqa0THqpKbCtoTeHrokz8FXvU?=
 =?us-ascii?Q?St0LhwkR3FSB6OzzDjgPA3pG+86lHdf/LHW2rtpj1y2rWEcg56V8m71MNmDP?=
 =?us-ascii?Q?zx8ZWa2LMz5lnFveKNwewEiv+pWREfXIujeSQS5I+91aJnmzSjHpRyxWYjPy?=
 =?us-ascii?Q?44OGxFC1qEkLBX10VGAWe2b0lvCaTqUBb5jX5SHrNzxym152ZZKVdubYovuY?=
 =?us-ascii?Q?8XMY++1KmbGR4u+s3OptfhfhhAhkKJwXIsE+yNjhj+cvIdXyuH5GdIHhZwPZ?=
 =?us-ascii?Q?Kx66yMonVcr7Z+ujxlyC92Bu6WhASvQGFhUzjEVdzpUP5xuoOabJJc+D6xfW?=
 =?us-ascii?Q?izh5oU+suKB5AvuOjPLxCD0F3tCtcnEFxSnY/Bk6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BWQNGD7wnecs4wMUiTUKN9pAoNpREcI279y2EpFvHRYUvReuVpGAeyO+nre6?=
 =?us-ascii?Q?cVCNCQ3bdKTWe0v3ZOnyn0Oy6F390NX+HZihJKwNjkxNJUSumgV29ucMEK0W?=
 =?us-ascii?Q?vaFo0r85NKzczvRsD146eu/eZmOwjWlLnBWIgzg86eXoZAAcCCnnky5v9JvX?=
 =?us-ascii?Q?yrAoeHdBd9qAxM84TQ3+AfOH6rZu343jN3vZlAfplFb52q/C6l867vvIUJJR?=
 =?us-ascii?Q?D6LdqhA8ry7VthBnwxctkrH7XhCv7n9M9nCl0VaEYfX8gDirop4ItwT10y8s?=
 =?us-ascii?Q?ofldz9X2UU2DNGZKVaOlnS9t55838GLHixrdDRN1uR6yBMR7iNjsrKHQwGJN?=
 =?us-ascii?Q?ZGaGBlNFI3c9kfBxCcjy6sR9IO9ki/XtlABc06d8lEJeZDcCC79XwVLXkEb5?=
 =?us-ascii?Q?+PE9bmaTlrQvbwQYNu7SGWK0iaQW0p14iLfChP9iTMe4LAevYKLq0crY4DQf?=
 =?us-ascii?Q?ZywkMEb1/jVKgn4rhBv4JD9SfLQ12rwzgRYszaPDFvEYYZ2x0uN6EWvxaeow?=
 =?us-ascii?Q?cXCrY9r6mbqHwUK8YYNGzC8KagBjRtSClCbUimpHYsVgQxCxcChjnMmKfGE9?=
 =?us-ascii?Q?PnRbZuZB4Smr5bhpsH3xPRl2dbf+1hMCQ2+MYkncWOdT0W8cW48u5sPUb5UY?=
 =?us-ascii?Q?IAKDS8XM+u7Z+KG2P3l48YNYG4waOXp/3Am7/P0z4xx3sgfZzfFMhMwhjjRT?=
 =?us-ascii?Q?OK5H/QJUzIRhxjMpv7PJd+CR9TGkY9tIL/wV2IN/iA6wRZ48DEtBQrMZW/uD?=
 =?us-ascii?Q?0CXZjLRbNhY8NQ4+6KabX8vlhXPXeojLO4MMzFgQu+tHIJSj0tDkoQU9KgLb?=
 =?us-ascii?Q?8dEbTxL4UrTLYzXGbo6ioG2I3b8gEh7viPXRdw2ImbMQkPim2+itvwB+9cbj?=
 =?us-ascii?Q?sWOl+94AbLNaO3WZOvjr5tSI91py1u6xaI3QHYDCGUJC4sLZ6PTKicxlC+Ic?=
 =?us-ascii?Q?x0o+XumZJM2cbTkBbZllwJd2Ol6bEr+HVJeXztWxteHvx3oOTCNFZweVFS9x?=
 =?us-ascii?Q?67kOSkqWQiDa4Yj2LYlYuYl7OYZsFQ3GXq/QLBfQM1zAXSwC5HhzVUw9MMz8?=
 =?us-ascii?Q?KQgLkgyHt9TjmFEvhXguTISqvn5VQ/VPDqH//2Cs0WwLsFjqF5ef9xkPZ5fb?=
 =?us-ascii?Q?FDpjVisemcDYgf3ZWwjw0zVaw/sEYVA0bZqIJE4iAdxHbZZqr8lFS1MMfGwe?=
 =?us-ascii?Q?dZoFB3U/NGO9qd4hYYuIXyLWp7KjuCoH7u+E4AifYosBSO6WLKX/gQbVaf+7?=
 =?us-ascii?Q?cDYpJ/TuexgcSx4begUhI5qYJl1W72B4GE58SaPoo8xP0tjVt+RcBWir88NG?=
 =?us-ascii?Q?G+GK4WA9XLHlLTHopBgkGkpvqAjODHn5BExMi9muLMrHXgvkwefvAuwqwkLr?=
 =?us-ascii?Q?KVLl9DAFjQ0niLZ1AyBFHBcBKw6s8yYo1mxv1V/7r+pRFGiJOYKVn68TqKKn?=
 =?us-ascii?Q?iGEjyOw9ywV2HAIjdz8+tTjWyLrP7MrGWCuuAQEGBnMAeWH4QImbBjW5jF5C?=
 =?us-ascii?Q?B0OaBe43XY5T9BFjgkkn/CbFGWc2/BmcnhZyNL6Wsaldr8davp69RIzq2DuC?=
 =?us-ascii?Q?CzikZq1tGMHNPvQEX4owaCIT7nICfbZAfen4NC2z1bUStJgt80Eie2I28AD7?=
 =?us-ascii?Q?ksT0CsseIyLZMFEPqisOEgm6TomkByzeF5BQDaT8pb894xM9ObnQwv0dZnpE?=
 =?us-ascii?Q?S5WE8HYtQxduWjOsQM8EuSKyIj1OrN1nkSNlgFTujRIgy1cruj/IjyyfmpDN?=
 =?us-ascii?Q?nKA5HEZq4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NQ7z+JGgCtlG459rVwTO5d8HRhzgEXm68EUJW6DDi0UuZIb0QF0l4hutlNC6HkrgDdGODcQSLpz3LQsRBFNZ2G3UkGcUpJjQBV7LaFUd30g29GzcVio9KGRvjhe3fLh+8v6MPZbyE6pW1SXyTqHJ5y/Q/qePEjPKKtYnAU+3pUCCs7+DLLYjJkcLfWlZaIs4SxIUB5GHR+a6Ses/NepG/5X24wcXVL919Rz6yNBeql6Bim028M/I4NwscdpOIegLpHsRlYo+s1nZFJ9/Y5EOJNXZptxo5/qvckzH3MaUIon25B7VcwjxfoPynF29nVLe5s+UK8dYK9UZKMshNgRzUVknHCqrTVWGGqBC9GVqz5Q3u7bM05jSgHeWm/h5E0wMUXJ7Am2b1yipwjnOKikkvWXJX5xYoay6JvhSqTDy6CPJz1VOqtUIl5PNFEJQk9KK1Wo/PGflvmx5VchB7jU+QS13tWAsRH9Tywj3TM/MLJcXltf1+3hVkrwlaJkJLDeve8zxDPtjiFyrr733sRcUH9x26BO/fyGeF7/bRPHZOuhGCRujXoRIYOXt5pqAbln51sws7B2u9yoNmOrwvzE44V7kvQwiNKrjsnHhGpp2ZP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1afc20b-528c-4a74-ea41-08de72e02153
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 13:33:29.3448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjIgYk873TtzIiohmlZ2aFpgZQRMOlWS7xA/+FtWisGcz7Uk3BjKjktgA9W5Nb3vuutk4PTk1JFbSYJGP9P5Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_02,2026-02-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602230116
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699c572c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=tKWSVBok3Atmd1__L10A:9 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: eBncL023f5z4PCjM9FRb-xODQp1C1k0Q
X-Proofpoint-GUID: eBncL023f5z4PCjM9FRb-xODQp1C1k0Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDExNiBTYWx0ZWRfXxlVDAukfDVvb
 qe/SI+Jrx/wk7dksEtSRkOPzp6e56ouMrpU3+UXh/kgmlHjZK7oXe9hwjO+gHy09ezWbhJ4KLiQ
 SMLlkwyPArjHWP4YFWzmgosaC/7s8biKx0mQDhGBGC67IYRCuAV0vettRGeSk+L4zWNw4sGdQbQ
 UA36+X0qbc+0PI85DvZyCGMAxs3kk8uDiOSEgqYkzDGliaHXuhD+6LX/BRP4LiYMwwFzfu2plXt
 Rlyar9iHPddla1EauRMxrMhOdl2vhxoCoA63d3Bl/ynhY0g1/xinXzb9+6p0gs5E6/YR+EZOj8G
 QXzX7cM1hXZEFIPSq1Nxk0ScHPmq5C+fpqBHM+3jMLy84HyBN3EbthmKLlQjDKbqOpyI1RJ0TRb
 c9lPILVtc+sbnfbbYoEHae5FWz4sUONlVuNyAABE6dZprpJHljNBST3krOxjQ50QOVBcz+UfMeM
 D2WI7gga7qhEF4Z2YY2LBE6jil6yCVJi8/rQeE18=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F3EF140012
X-Stat-Signature: ikncus5ir8bkzb5k6icirm15p9up4yko
X-Rspam-User: 
X-HE-Tag: 1771853615-177986
X-HE-Meta: U2FsdGVkX1+SituHdAcxBWzQ+P/eUfxqKxgj5LZ0+KJCw6hlKjPOJog60aasg8YbaytTDa6wHN1Wg7DYCYpv+/5X1M3I6zwF2Uyp1Tmc0RhU8GRII8FHWZqmfjrlpFKftcevvgx7jDCwSj6GpRFYk7MhMBg7pMJNcoeGfjaX49gGnbJFuqOtQeQg49diPPwRMriMOf/h4Hs10znZNyaVIRLxhWsfhD3LEO6+9QMUXiwrC5sUiYxCz4A2fiXwo60TjjhdwmkJ9FF1C3/ygn3b/TU+2narz2cWyOvWEInzHrVzQwnRNpaktg9yDdHiFNEuFcnRn6RnyXtZ+mSv+UG+mxldBzLgvac4SdkRNcIKezYSfBwpoUW2x0wqRwyWrG7XGDiq7cdw0fDl6DdBkN/l4DLmi07cFU6pXT+vVLVH3PJmquejFLkrvAM1Fx8sBS3RfSVxM/ZlsNr4Tw1dAdTgBEOnZTPE8gTnoqY9biYop1mG7wg90XW8wfMFQxIPkOMqrAzYVR99avfqZRnuB6OEiDSv21dnP9H7qvryHid3EKDIuQZLe/x8MHREgImj+Pk2zt3JBzJV4iSEbD7qsyh/YY2u0m4hQuPJJrO03AfJIW69zAGdGcMCvj/cHlPXGIc4kX39YrMMZJPXgrOebzlmVQ1rlC8nPd1BZIeVcRoWjCcCsFx3zMM5SiZfG93jpQbumvPNqE0zD8Lxx0xg5tE937JNl9oQrGugib4/qFf4A/xXks7dbZgaZHCAlG5DgbvFy8N61Ns078/eviOEUai9X8Xx1gYDSHe3qvMR/qsCtJr/2BBDOyUIjyJVQJmoyLbRXgxyTnCctdsue9QM9xbhGhwnEEOMBE+s/tw6oxa8AuxcyBCaNKqWnoFqMKt71WjTPtyshP+JMuDVr+AakXvebmnvbHgTCIx3Wb/Bd0wZr1kCOnmgtCXXgC2Z6om7l2it7rHPnmyffqMKy2BUL5N
 7nSzqwuf
 /1NVNqzXymesBipbXQSeYw0TZlurT2BcqaCrSUJLEqSx9Ay+RM9RRswXaZGBySarPNJb04OBHR17t0O4nIoUeD3GB7+UlnohI3dadPYT34twBLL0pv0RjSCUCMbIBoOVAwgXds8SX8h6lKq2wRLOV/fhRC9kbuQHdcXeXCP3iotLMlB1/tokzpP33JJjiieroAHgbrBbwigmPUwkum+D8dZycVAyrX9USgO0Mz7yRcGhBURMUTafNziH2njNoiOnLr1urNi4Ch8SOTJ0t1dXawWKPioHFIeTgaIFlGKM67/6FAK0hbXV73VwiA208WAdVh1vzMjfToF7KUV29PUYLgLyhRfxGYWo2xEwVINaIziXLG5aEmYigjomXlTsUln6tWyDzDO/SSa66gq6a2iF6NL8aZoAfyat2EpkORWTN9MSoCbLktgey5YqgnnfOIjj+m7Z3CYsDXktyuIVdbmnWG7ktW1j9TgHrl4ozjm24H5RReGNZm6ftTJZ823N53s9NFKDCtFmPqSYT/i+yOz373KjpRYcpyuSRkB8ZqA5uyyVg6tylA1//lyzut9qKPYsom4bb6xh0viEOKi9VB4ObjjeO67Ci7MUpdXE4Sk/TyXWHoUaxBOrByrX/LIStEb9N4VSMqgz9C3EFU1LDLov0VKkJuSLGR2VDTU8p9leFHjNhLnM0BrxqO4xC7qeomLE8aV2izfYfCBMiYftUfIgCOZ/RZKv9uaCL0VtwlqzY4MV/F4UXWjCyFeqWfxeqnkzNO6rX5qtvsQFpFv/+l2Dp7gRYvAAS/z9619uzz/2ZkfNd82s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When refill_sheaf() is called, failing to refill the sheaf doesn't
necessarily mean the allocation will fail because a fallback path
might be available and serve the allocation request.

Suppress spurious warnings by passing __GFP_NOWARN along with
__GFP_NOMEMALLOC whenever a fallback path is available.

When the caller is alloc_full_sheaf() or __pcs_replace_empty_main(),
the kernel always falls back to the slowpath (__slab_alloc_node()).
For __prefill_sheaf_pfmemalloc(), the fallback path is available
only when gfp_pfmemalloc_allowed() returns true.

Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Closes: https://lore.kernel.org/linux-mm/aZt2-oS9lkmwT7Ch@debian.local
Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
Link: https://lore.kernel.org/linux-mm/aZwSreGj9-HHdD-j@hyeyoo
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index afa98065d74f..0c986c240bf6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2823,7 +2823,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (!sheaf)
 		return NULL;
 
-	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
+	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -4576,7 +4576,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (empty) {
-		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC)) {
+		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 			full = empty;
 		} else {
 			/*
@@ -4891,9 +4891,14 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 				      struct slab_sheaf *sheaf, gfp_t gfp)
 {
-	int ret = 0;
+	gfp_t gfp_nomemalloc;
+	int ret;
+
+	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
+	if (gfp_pfmemalloc_allowed(gfp))
+		gfp_nomemalloc |= __GFP_NOWARN;
 
-	ret = refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC);
+	ret = refill_sheaf(s, sheaf, gfp_nomemalloc);
 
 	if (likely(!ret || !gfp_pfmemalloc_allowed(gfp)))
 		return ret;
-- 
2.43.0


