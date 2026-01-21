Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B60C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DFF6B00B0; Wed, 21 Jan 2026 11:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CD86B00BC; Wed, 21 Jan 2026 11:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127736B00BE; Wed, 21 Jan 2026 11:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F15266B00B0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CC6013BBA8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:03 +0000 (UTC)
X-FDA: 84356575926.07.857935C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31E16A0014
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:56:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kDeXKUN6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GKKS2R+q;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=;
	b=5F4R4CXNR0Jx+n/qjyOtQEIggeMt+3KJA/kpj5MUih9Gv82lErOPYwVsBSeOYDvJ7NeHXL
	fgC1+ak1wby4up2j1CCTfMmICsahzImmvRAQeo+f7kslKz5qUuWbt6SBRRuKJzDDnsHnnp
	qr4CxclyAurp4KdnslnbcCbxnIvqtFI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kDeXKUN6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GKKS2R+q;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014620; a=rsa-sha256;
	cv=pass;
	b=4E9ZUnEGPTKKVFo0Tkdk9eVUxhZEU6ll/VjOYVU9NDCbwqQtLbxU81Cx9I8nXLTgbmdAdB
	V87mP6vygjL7ynsboBN5/a/RE6RYcFIFZz4Gemovsg0TDGdDBtw+bBpIAxrQdeU0KP0toO
	MZ/gjJVYz80+eX/hLSZpHmQb1bFIEgM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCBH6e3418516;
	Wed, 21 Jan 2026 16:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=; b=
	kDeXKUN6hceH6gs/zsP7RJKKsaiCD/fNTobBMz9j4YSs9fUBYFk2X7gkRPLcsM9G
	iUqwGwbVUHNGw5nHBKbes61JBAecQ0/S5kGgrEcEurQewNIxh+C4RdAMGKLhpC4F
	iiedh2GTdQ1vXIiICRnrRcTuZ7HWJ++I+d5FD8CwWeedlR5+hBALopSsYQ4FYrBh
	uk4ZMTF03NZk1V3z6b8vc3x6THkceRk04u9gyl22xW2IZ/pe6rFR9VpPShcvGlpr
	qYcvRWKbUZP3MeEMw2SWIkueh8AyJ/SxOpCg8m/3S9GMTJTKfk7eGujN5coLrjD7
	ou1qZT0h7mh3p0Zs+oXtvQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGKKs7008437;
	Wed, 21 Jan 2026 16:56:52 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhsfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ye3tlgPT+AjadjaZNGqhi7JKuqw4/RSjbq+It1k+OsQmi9owsZ/xKp7H2RAESV1Wy52bRL2AKTizo3BrfR8fS25YWyyNFAwOdluQvAkLkeuObDe5lv2OJmcXXpsk7fDwjJU8wUT5vZLBODrFmaf9grQ618nxR67/75SEY5RTWZ6Wp0p+o2V1B0A1Gw/KZc+Z20C/1gM6Sjde2FPKpL7xNTqvAPAJoQ8xK8s7YHydzLWbBRcDAhtOv6Zp05FgE5VCwBUz/Sgr8drTwlIFVbrMGLXJwWa6JRY9Tu//4GfA7tUQjnl2esP8Cgd9qc5ONYV5InsvxG1gfxUlp5Z/aRNfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=;
 b=dUeMgoz1USPo6ncRMzuwhcQzHx7nSGdy3Y+c2VzO+WVWRDAPgC5o4KvXMVEctS7/a3cnqePsXDlxvbLWC/o3q3TeiTjyZZ1ImDs6eVI+jFvItXpfUNgeQaL2+95XtOuW72b14NRrzmkAu32cYWasC0MDh1odGV6LxCZvZTfx3t1utueJF2z8eMwhaIjUlVWG6w2MK1t7qAWvCQlx+vgQoveZRbrC8lDQb663mT0ZzEnmYbZHA6C10ejQUlZk+zv/8wfLi3ckL30tmx7XsxAxIMGge23kulbvSgETWGnHm0YaVseo5EumNhiEEXJiEOU1nBYwGjj+QxzmFHRWdFG8xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+paSCMylJ4zGtmQlkiq9rkiWuy2a+5XA3oGRYJ+hhY=;
 b=GKKS2R+q+nJSLN3pG/xoB0x52lG4GmKaLneHquFNz61EEvVk/US5lvoNBJblm+cv7QR2d7pgiZOKChrxO1zClhsI4MhBL8el9HvR8+0BUJcAFfMw75bzH0yCib3+gLeCRaQoCEuz9ec8r3fkqCZfBKar6LRWTXbUFMnZJOY0XOk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:44 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:44 +0000
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
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 01/29] maple_tree: Fix mas_dup_alloc() sparse warning
Date: Wed, 21 Jan 2026 11:44:58 -0500
Message-ID: <20260121164526.2093265-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0278.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: cf796e96-1b90-4e5d-8c6c-08de590e0e76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lvCvQhevJ672Cwb/k9EamN/9jIaJCXardjnPfKw2nY7i1Nl3GgrtAQxexm3+?=
 =?us-ascii?Q?I7xwhGmFI/zMZmqCNHGyqfrd5armY/VyuvIiXeyDbzaOyV86+tGZ619r1vlg?=
 =?us-ascii?Q?YewxX1fOmc1lhu81fGDTumoxe1aLvo34xdNZY7g+z4dHKwPfqd2K8tOoIXnD?=
 =?us-ascii?Q?WDuBc6OYeTeUi7cZJVvnPOrON0AREU3oD80wdGCslRODouaWKhkUDYunrqcI?=
 =?us-ascii?Q?IA8zJeYWSqODKzVuug+lnGWUoaXC0AQQcyPY3kB5KQlYCnmOt56QRp6cLtL/?=
 =?us-ascii?Q?FFFyLW+2DcJXjlX0vfbIlj1wceJFDLT5NT43eAA4t3S6WAezlJxoLy+NY3EV?=
 =?us-ascii?Q?Vs1185kCFgkvzpt34PP8BHSFfYYCMLqSMfvTOdw2BTv2TOyQsTlN2wfK3Ph/?=
 =?us-ascii?Q?wkHOvvqXtVATfdkdhZGCel0pJNyqNM+wWLcpGIu8EAWqw29uhPtdpHGZKIbk?=
 =?us-ascii?Q?PsPI2pAlt1dJcxKD9i/fCObAEljCysFKPsRWos2nywhxV2mpeBWTsib3EAo/?=
 =?us-ascii?Q?fGkmebRIhidOGdzkLdPNdJdzGeRcgSXXSftevcqHQ/gOiN9RMuqoAMNY8IHY?=
 =?us-ascii?Q?rXaxOeipBkAavb79M9mVyCceobmKVYHjlBrUs743N0n96uEJrBRxFIfQuFJa?=
 =?us-ascii?Q?Imbg5UcWbGMI0iuAXGKh4y9XQQHemA0488ORVmsC1TO3P0zBprbxUL9RppXi?=
 =?us-ascii?Q?1h+b8KaiOIPzEk5xATLViL6sD01JIzCSKQvidgvat+NlO4aH0yJUorfwLMlD?=
 =?us-ascii?Q?A7sElRBmpZaawFT+8Dej4UyZIPo6XXrO8p52AYSW5frfv7d0soXAzYqYatdt?=
 =?us-ascii?Q?wtd+4bYU/2KTL+DIPYugFW4PCqZub07rtdH26FEF60q2PrICF9YK1jEgzFkB?=
 =?us-ascii?Q?6SoCzO0Ob97BhmiXFPMR7OVjkEChUTOSxIobC0kjT4gtc/9bEDKMd6YZP/Zd?=
 =?us-ascii?Q?qI0lXxMIIoE/VwSGU/maAqC5Onb5aeciBrJO8+0l0IyJQ3xAICbzHZOP+Utt?=
 =?us-ascii?Q?Wi8aPK1plXrB954zPWmJz0K/VG8eqjvoPigyUp3fgNw99pl4fAmHwEy2UxgJ?=
 =?us-ascii?Q?IExP1wMnTqNylwOR18cYdwXf3Cl9TLo6AsmYmOK+nBXcVP98HGQvT0n1vfo+?=
 =?us-ascii?Q?G7F9ufzg/5TDyvM6Bual8LnlFc7Nu7jDtf1zFUdWrDudSrze1Y6SglBgelFq?=
 =?us-ascii?Q?l3oVpAZwTfgk+tME5k2+90ui8gTA/xgCUJiKZSzCNNbfu8o04A58vwOsKdUN?=
 =?us-ascii?Q?xcPMs7x+k2A60lw5LY1t6T4yEI6znu38G542hhmkAn/s+CCTGUtg+u5irkId?=
 =?us-ascii?Q?1KnkDD+pHdJc1EqbpWmMC9aeoooLu3+JqEylcdpZl38iQ2xPpOvj3r/z1OoC?=
 =?us-ascii?Q?Rm4HMx+ypvxUynsaR1P5xusZMFiibINgXQM398B1LeNBF73JwvUhel0rCAPH?=
 =?us-ascii?Q?v1qUW+h1KW2Icn6AwEVq20kzDr56cRW2ciiG1AfFp0sLiroziKX0bNKsC25g?=
 =?us-ascii?Q?5pDt3YEpoLxpOmcxpyiPHkU3EEnAZOP3iyh6L9D5qBwNDKkOmLuBBQRER/NY?=
 =?us-ascii?Q?RQrVXpwUc/m7i0ypYoI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bEdOh7oG8vLuOqIUvhWNxsrZdKz3+cyb2qQpsJ2F1vUqiKh0UgzC3WOkFKGu?=
 =?us-ascii?Q?QpLDloM0hQuRacczdlBowzenIJErMele4d5nAfo8bx6rq9GZK+dRF3z4rN6g?=
 =?us-ascii?Q?nYA//S/4YKNObYhIEVfbqo4MdWivG8x7K9SnodY6X9DX9Cff05SjciTrNlww?=
 =?us-ascii?Q?SWNndpbwP2fKjMB7tcB5uP4CddSEPHfrlQdJanG89waHrkz5Ze6GPV6jJBIo?=
 =?us-ascii?Q?8qVT6yQwK6kbpihVdrdE11qfK/ilnGHzHF7jmJ9f5mzcGNlrFdYMwgJr9LpT?=
 =?us-ascii?Q?x5SYovqLqSy+0hX+1YZGYBgr7Tk5uStH6WjRo2GIk4wV89sy5e4z1c1yp+9S?=
 =?us-ascii?Q?j6/05S3VUtOw3nOLC7iceuqs6SefMLWmREUVlwKLuA6a+zSsLJyAaeoAYeFc?=
 =?us-ascii?Q?X+QNuZbvyRhYEKv5L/nWhKfkKXLU59OfVXJy3naeAQBlBy3P1H8DkH0sPcFZ?=
 =?us-ascii?Q?GpaeuCHPQpvmLnniQQMv7kxZ7LaZ0xd1wmVKN4dRH0xnVbBf0MBFrnOMG+K5?=
 =?us-ascii?Q?mcPKbNEC+L4NDPIQsgaX6pFF1++9TUmBFAm3YwkPHo3GkYgv9EozTJUIVgAE?=
 =?us-ascii?Q?Kgcqx+Opo3YhRdHFP5eaT42LNoBewHdxRC3ipOTpVArrh5Fbcf0lxR2IjbYh?=
 =?us-ascii?Q?mAYrhT1rXlqnLscDx83SFhr93aju7xzDCgQvWrlcz4WUET1QSsNxDcK4bGrF?=
 =?us-ascii?Q?0l5F6D00dCbJt24FckfgnpDwuwWpkFP4PmPOQ4hWZpB/RmHTj6AfklkjgF/9?=
 =?us-ascii?Q?jLqVYov5QGFr13UFIdb/V+bJy7r0mjkzLItlJwVE8AX1bgUjzlTMu5R7qQDI?=
 =?us-ascii?Q?a4P/qOuQFW6JIJFvUuAfI/wHcMRpgWJg78oRgzIfGFjx82Zva/tfNOIeXt8q?=
 =?us-ascii?Q?S2u4Da/1McyOTZotHNJQl8T3Pgy6Mb3ZfzxMn07B2FCZqfvJlC0QaxlEC5xD?=
 =?us-ascii?Q?qEYZLKljogpnOXvc3IYN0vvrBzNf57qInq62K0EHLtlxdUY4w8NII9tYN9iO?=
 =?us-ascii?Q?bd+yJ5oq2qEfxo90QhyEB5/igu2bmsi/0A4pMKhAESS//YHGPg5LKZF4isCj?=
 =?us-ascii?Q?UulNInPyF0E66ZbpjR6G+y/8rVQM7zc6Co1hf4LOikdp7XvHqWw/KqtRojSx?=
 =?us-ascii?Q?0b5qDPJ1jo+O7+CiaPEifiEphVANIfGsjO4OmXmNJ+sfCD5IYD2r9AIm/zU0?=
 =?us-ascii?Q?0yOCb4wH7TySBT47WmK/fLbB7QG01RclEZYKxVvxT8EXM9hFxkxUvJTqxuQ7?=
 =?us-ascii?Q?8KrTRyJ5dxZWi1PAn7CrpetkJZTm88zaAQoPy0i78WIYjWGZ4j5+zkY525ly?=
 =?us-ascii?Q?c/CSBmohHv8UDnazRJog6m0lTVAp3v4TmK0/+dhurMWbWsolcgFUt0ZpliYP?=
 =?us-ascii?Q?8gOqSrKd/fexz+e1CLSwUr/m2wfigZ4V+hpvQS4Kn9fNdmB+FiarluCd7t+P?=
 =?us-ascii?Q?82PvrX8jT3DktZXMmV4tA7x3DeKm9ClI2F3ZhKDVpK/ph53XRJQvrTwqJaXd?=
 =?us-ascii?Q?v1RVpGcEIZr4ftpWVSUIbRnS9kdetXnsnZu9qJ4Y0MtcVUm3eVUaBLFmlPoB?=
 =?us-ascii?Q?s4eZN2mjFBFdRK6EPSsqPoWwRyKdXQh9S8b0fTQZ3iJo2Esg8Spguit4ZkJK?=
 =?us-ascii?Q?x0h7CIgB1kOXNTeMFiPN6XZQ2YcVZWo1xa7d/3DHCS0NrK/QxwDxOKv1xdmd?=
 =?us-ascii?Q?Pjg9kccdLtgABpEIeJMnnMibp7uHOifQGwVXNtFOhLC3JQC3oSQEBsDDpyrS?=
 =?us-ascii?Q?8DZZLogI9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HOtRbPxtWZ00DPJh1mhQDzn5Xj1kATMQ6p0omkCrDpbF+FA/hLqMRIRXR5OHkWgHWujOE3WFHdf9bmhYFMuQj85cpfud0gLcl8ptaYroCpRKlZmhyALbg6wF0yV4r3ZTH1BRTMGXDBiNQntUiDBrs/movdtEytAXBphZRtlMhnYINwVIJAy0ksnx9WEJFdBISfpF+tXUuNu7x7vXw7b6pQxKf9B78XJj/OjZEeOqB+v96ygnpjQpOiFBjg3JjcOeI0sAEMHYYNB2qvjDnlsHerB6FKXZmcwF9/R4SZZSfkIkVTND6zep40xpqptxlOSBOETpJxm7caSKPkoM/BNSJneY/Wa7IRbjC2xnrCZO0WfusJA1ZbNX2xHGGs1lhZAsnbnX9VsDarumZcFfthmPrFiC7Rv3Vp/wSF6ea+1yqEjlwyF2Deflb9H2AWBJe2y9FHS4dsKr+CGFoK2j1XP//Kjg1QxOQEZzDO8gUthxIKyOlzDoYZ3xzvfjCJcIECOLWktNiKh2FgeKc7KdC2i+yQksy3scuUir5kfM0zOXE1nH+vUa3A+/4wEzm5+31RI4ky89yFaTWTaMqRbDUTnws0b3FdubHQHjTb3lRLD9LSA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf796e96-1b90-4e5d-8c6c-08de590e0e76
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:44.1219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xy4LyXcmW3GI8RTlPstI4ESeWWOSszKBskPiyKfBpXhB5YeWBByNcil8wMFSltO2RVpwWKFKFrp410/ctyW9zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69710555 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Y5ejhBfbtcslctzzM8EA:9
X-Proofpoint-GUID: upndLhvKX8yGBas1sQWfJEn8xcsE6lym
X-Proofpoint-ORIG-GUID: upndLhvKX8yGBas1sQWfJEn8xcsE6lym
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXxLcYVx+zEoWs
 Yh1ONNGEGqLizKBwdb8P5/Ynp7VI5qwbhMB6wkLN0WyCId7qPWpnCy57YbkKiJAWJgOe/acVPYc
 SriD7W3tPVyYKYRxHq6fn4uj5+4BiqoWXsS7ABXfn9+IBPD+u+iVzCwy3dc2hTilcb5kFUWcHu3
 WzfChUi4N7qb+esvg6MHcGqxUectCEUuyxss3g/Ddtbk98hJZst1KpEKB6NWv6dDxdJuce04gaM
 qSEKZllljpvjh8JbCGyp5k2b4Ul8nu/etswSDRxIEN689E/lXbCxry55yIP8MBt64OAQrs5+V81
 iZ3zXcSIkACXw1o/GJM3SFBWQcCVbg9uWoLzZ7r9zwRed7Vfz8Og441PJ1y6jsN9zOAdfW+YF1f
 0FzKu4FtzqQ9Z0SXJvRQ8ubUMNDPc9NlHVapbdWC5bTIeTYxRxyDAHKb3QCrMvLbeLhoZkyfmKK
 X68wfXou0JIuchqU17Q==
X-Stat-Signature: qi188sup8pt3zhx5cgqcjdcznazurwh3
X-Rspamd-Queue-Id: 31E16A0014
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769014619-556556
X-HE-Meta: U2FsdGVkX1+tY3RS+NCgmWhFvvPXwXikXmJLCdRweueYwi+L1FnBMWbwQ30X3Wk+tfi94EleCTv5JX0+7A4nGcvK4D7TSibQ2bRVZmY1mkS7GwoVAgV5SZY5lQ0RtPOeG/lwC8Kyx288VVh8MtGVUXXTv4I/DNosDnXzhGeJOA/Ok22BuI/IvII6BrldWUH7k0ZCEJcSdZsJkUDMKv8YlcaRLmr/jIdbhKYXtzb7fktoqiMUL7paldyZOoIKC4LV+HkKDuiQp4mOui8AtuXp2VJ3EzVCOkujZcpZlkHpW/DO50Q/WsJKAruEDfx2dLU8qIZrM4mvf2X1IRjjcb4OSMMR9EEqtfXz2VR9+u+Y16GLL6VCFny/FrWQjMAC+npJEKNcgMlC+Krx97cZ9qPtM4BfAmvQoKxOZHJMCTkECMpSjA0t/OzX8RzXPTHgbsMPkSWROBBmwJ0HFBLAvazrsFvPgMHMmR3xTAAUgqijwPezlPrNA6cr2EKkarnDxitGP+KhVTopQOR2s0FeaMbKOjcMMAA1BcvmwIMFRDq/wHaFbHErhOBO7djxY0RwdORRbYO8ll5yOcNUojepbzBUAuaEEVFkJEK7M/9GGnXw0FimclEy+dk19dB6F76TbXSqme3eAPoxMP8CKq1i1mJK4Fw4sWdLcGkFp+XNnfwWf/lgwdLkVh2drZLBHdhe0qYBvqYQaE0dkCVHUJL+DSWdxZWZafTkwwlvjvG7HE0TrTGYYX/TZS70EEBD+7qs8EA/XaQMzOhr+qPqKJ79hUqxNx+Yr3NXRpKT2XUbiYWZ89kNd9wQXB0U1cA9amxUggm2dUzCXwmy164orkKV7b/HowltBV53p/9LC0BEtIyX/VQT57gvRXY0Virsplyn+bSMO/nQbkVKHoNLLlIRijru6+/VmUMA/nVdYHHgcbAqIZCF+689HCztOazE9SrhRfefro949EY8HGctYONEqwF
 xOoq62hk
 8bHMEXetAdrREvmuQLK7i27nlKFksrKzRgeBMdPA6YvwhIiZNlvTW5zF9iTLSLllrbMHVOobJtKNbOLEQYeMbMq3QlBPSpJXnF4FKgG69Hk4XbGhM8oAokMqMIDliAz3lnbPnpV0SVJyPItwZLBT7u9IGJaAKIHnhxjzdyvW20+xM+JWW8KD8yedJB3Dp0mxCT9kFFzRRM1fohBq27RxV0Rk88Zs+i8UJddgZbBuxQvvmnzpDsHuR8Al184bPRHhH7NdRCr1J2EMvGdDAjIEVZQZDjwkw9GskqM8cmgdWvRM8W0+3oEwd6HiK4rvH/0i4YO6jZYo/rtC/QQ2lhjaQzd79MIeaHEp+WHx4SJsllfp8FfC23uKAWwoxR6xsaleIqw7FEYwtbHDxwBcmFohIjLDnJb7sbJHQLtnaNZp5/DmUdMDl5LWSvNJjCKTLK/XqmlxyZOGjZWsKtTExpw4xpwTZLnBrepXJDa+VV4VbZiRmtwPW1UCoWJflvlYRf/lHJwxPBX2bf9cXG9+sUXx9uiA8K0MR9lgAWzT1vnSY0TJZipHwT/t94goPEyj0CsHxME/F5J6nO/9Wkf6GCDFmrpjT8jC5NKoY8aVj4ePtVWc9LjM6tXE4ds63pbIYxihAm1HJh11I9eLV3jXa8sG0WUgI2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use RCU_INIT_POINTER to initialize an rcu pointer to an initial value
since there are no readers within the tree being created during
duplication.  There is no risk of readers seeing the initialized or
uninitialized value until after the synchronization call in
mas_dup_buld().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c95000188..0e0158ee7ba55 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6260,8 +6260,15 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	for (i = 0; i < count; i++) {
 		val = (unsigned long)mt_slot_locked(mas->tree, slots, i);
 		val &= MAPLE_NODE_MASK;
-		new_slots[i] = ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
-					    val);
+		/*
+		 * Warning, see rcu_assign_pointer() documentation.  Since this
+		 * is a duplication of a tree, there are no readers walking the
+		 * tree until after the rcu_assign_pointer() call in
+		 * mas_dup_build().
+		 */
+		RCU_INIT_POINTER(new_slots[i],
+				 ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
+					      val));
 	}
 }
 
-- 
2.47.3


