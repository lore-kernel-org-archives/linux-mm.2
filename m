Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7018CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75736B0005; Wed, 17 Jun 2026 11:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D086B0088; Wed, 17 Jun 2026 11:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C6A6B0093; Wed, 17 Jun 2026 11:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98B4F6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:47:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23E27404DB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:47:42 +0000 (UTC)
X-FDA: 84889834764.26.DB2FFE2
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F11AC000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:47:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pXloOPlA;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781711259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8K0U5ANnenk6Sc07UT3LaR23ls1ZQp7UmPKXyUnRMA=;
	b=FRLYA+W3zpr8wXamoTgvGuGBCUSVGdLrknVlnuj4IpmkC5vdenynOLmwuyX9A1Jlt0skJF
	xvwK0n4oUSCR1QHBizXtKT06XQrF30/e0vXMWZ9RuMTXxo4aT+WWMeHJXxFbbJsDOFAj1T
	L/6rz2paSDdTkswTjFBS+O7ovRmn2PA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pXloOPlA;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781711259;
	b=xIv2BwDCIYcJNeVl5zEMAxWj05q3tT8cZEgTDxB1KSyBw0vqOL5OPDxNZ6Zetdi9/FwNTn
	Xbnga9gWHAggxYUq6AGyENwqhRcUgq6nBPCYPHX1SGFdLVqPnRpyq/tULWRydoD3pmfo/n
	ZxOkgAVo8SC+wSX7SJOFcORPi/C0zuo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNItdm35BweXAXJi127yONzGCpErnMTbs93c0x04tnxCc4OtewPPJVHc63zxwb2yeEr6tBfs2t773df29m6U59EOnrK1oPL2xbpjuM+lbc+cF7i4DwpLJki0T8Xku5oHzxioep3u7aN+S+qNYdSs9/eGRdR38s/U83pHkpyNmbduq0J04Wi8uIK0UQPzJBlmGmi7y/EmR6u+vmbQtln5Gjwmn6AUDNP8/KhRepeO5nVjB1jYiS65zmDlHaMKqIBc4lNGoyCNhrM78SiCC2LeFN9p6UIaA7I9f0wOlq99gjOSIVBSkpnGUQk5LnM0WE1EBIH5ctWCAuepdwBUZiwUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8K0U5ANnenk6Sc07UT3LaR23ls1ZQp7UmPKXyUnRMA=;
 b=N4XdSr4dnIKCBI9q6q1oKPDfxsOC6Vvj4mDtweQdL878QhmFIKGZutz/tYAnfzm3omscQNG5p2f9JGi2br8DeBxq5943lNrPevRkcANfzXdh2X/BXFM69VHFNYlr5bftZ+OmNgQwAHghqrKrpptFqtkfS6fHzHFIhwRfgqLfxDUIDNtvNMjDC29BOI4IwQtcNz4aODdXhRYOEct5qQp71o4E3uQqG0Iz0cJYl7yd0wCGbbQTnJ58/taZyoM8eyY9P9FFom7IacJQwiLEfXjK7HNzw1QWNrrrn10lyvwzxlr7bJZWrO9iL10mv+MsxId0dV93ViK6oFARHzvbo3mY9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8K0U5ANnenk6Sc07UT3LaR23ls1ZQp7UmPKXyUnRMA=;
 b=pXloOPlA3EUak/9acDuGsysmAO8KYzQ3S7h5M9u9l3tGWEQqaMisY76LMr4q6fVQzQuiO2/vVxrm0pRnOBFgUoOElH+to05oA2j0CaDC/8EYljRm/KZ+qtqoqiBPmh2752yZmAHXmG1yHMW5YOdPH3HauyXozTBjogG0NVRszsX+pgubgZbS45of5mZx/vlpcRM7iArT39IGA8/Woj4oKmQuzVmyILLN0Of0gxUt9bFa8qk8L9f55xZuMoore0FLYE7TSt7om/w3p9r+4uMQqaF5VR1KK0bLshVkZfJ4U7grqTRKU8rcKqBnDNm0Ja/pqD7vyts9BVRzcM4iOtPPKw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ0PR12MB5675.namprd12.prod.outlook.com (2603:10b6:a03:42d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.12; Wed, 17 Jun
 2026 15:47:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 15:47:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: include <linux/vmstat.h> for
 vm_numa_stat_key
Date: Wed, 17 Jun 2026 11:47:30 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B35448B6-4958-4FF0-8AB6-5464C2D6C50F@nvidia.com>
In-Reply-To: <20260617132726.1086576-1-ben.dooks@codethink.co.uk>
References: <20260617132726.1086576-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:36e::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ0PR12MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: 279c84c3-f0b2-46d8-5f0d-08decc87be6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4NTZZ6UmimBrEpLWsPWlaK4BrtjfYJskVP4xyqwkxB6yMK4LTl4L3dPUz3OV7qqPkG8GwtOQyVuaZ8bx8Xs/BFKspQuWJauD2qHcvlIWkZQwKjm8x1qSGD5OHdd55Qte76VyovE0bwln+EWQ3p90CVZZySOaDrpIpSG2AyQf1KL7HjA/imBqSROFgwVcu2rnCGJLbVJquIzrKqMtYh6xe8mHcB7IQe8O6l79jZSsmwioyjroO8OIGR/Y/OnMSPs8qrReJob0XueBW3So9NgX5JodulWBJd4ELCsUcQv17ZrAPLKnJNuqdV0lHzgKk9NdxK9y91QZm4JTW0pJLPgtU5llkI3VNwoPf0WM5OblPuLYGH/hqJjeV/yU0JgH3ocq1PtVd5bAjqVRwCFKykAuFAHl3Dt2sWprLHYMytyMY+31mSl+zguJ9bzoV32Zyzp3SZTzbbkrd1N7XDoDJ+IFT8M5eRerMozRx7XpSJUbI3b2j+YbtUUa3iJptpOHVAW+OWmJ9jHOUe/uHBq1IHax0nABgTC6lsfY5X+f1SO7wqhOj2AES19APmNtKW0tx10+DlkQ397s5uHsmXuZhqJG54AoMjM1Og402gW314sdMrOdQPP9TN5qMxEHHk4OOhfWyArr9dPraBVHmzcLERxw8LmNyibFa2iIH4OHsAPWHYgPoNSJMqpz5SpnEk6XnbZHhYQpZAw/A/j2ODYGxOrmGA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s5I8WDIO06nddoKmiDN4JDNgeHhzATc8UG7SFLPB9QB0OD4nBdMIElCV/qDs?=
 =?us-ascii?Q?FcpVAxXlSXc52CVAsnpqUYbsWFRWH9riJASYPZnflsW0zcFKlJnsxJA6V3IP?=
 =?us-ascii?Q?AlIovjBOBGlSExcXzyG0GkMY1juVpZRyn9EoeyMKDhcNb7OggzQgQ8OUKZcA?=
 =?us-ascii?Q?ENWqTfhUzUWh/qVEuhtaXkRza77Kf06HFztenXdCFt8ghkkkjLRLPKwv/naP?=
 =?us-ascii?Q?l/ZPX+0XlN6cBqGeV38w+H4D2VbNuS8U2/XY3Moa8x3L+Q617Pg6+2BBK3fq?=
 =?us-ascii?Q?tvELA4x2Q9MQkAkwsLWo9f4WxbIzZuUobdMhRC6B3bBdZwNAF5J4T38mVsa3?=
 =?us-ascii?Q?QPkVuM+JwHVAZP9E7WVqoGTg7lXX4TiSY668dk7gmZwKed7pcv+M/r9IsCCk?=
 =?us-ascii?Q?TGoI6J+5KVJ6CfbVpKw3PmwfviUHnLu859CO4cd8leSPoEHC0Y/t9qUDgUIS?=
 =?us-ascii?Q?9pmnv44s65C6LNGs5Z1rsoHAJOhwo0Ge8srrE1I3+DuZvFY1VTRybsx9HKdY?=
 =?us-ascii?Q?jOS8qI+pSd65x+h14KVfgfKhRqCK6frTCyauDIgYsYkpZk44XKi5tHWA9j2H?=
 =?us-ascii?Q?l3gV6/T/pAuuJyhQkquX17PupKZdE/Byocuowh4/bUSqSKQi8daPWl25rc4Z?=
 =?us-ascii?Q?gRKV1cYya3DYxERtoQrcg6DqjuXLOL3Ohga2omZpgyTXI7fC7L6qafp/eojz?=
 =?us-ascii?Q?0nwRfIBQs/Dbqt/r/o75sLxepJOSFDnvDc5fGVzm3H/pLjKZD3WLmUu6LC3i?=
 =?us-ascii?Q?1Ui8h1POeEddoxz0UKgHPqyM+yjdWYBbLkEN2YTiyXW7rh5Zksz4xDAxhcm3?=
 =?us-ascii?Q?r9bgithTMZNBtIYoPo3FJW1D9J7RNznaigNX2SHWEFlNJnE+51lumqqK9CI7?=
 =?us-ascii?Q?0AbUKezOhb5H44Rj5vhIsQcHL5/7UIKFGLVv1Uv40ResFVEZcIR9YuIchzqF?=
 =?us-ascii?Q?m0AVWCI0dRpvByptyNyitN00YJctTIMUaSvsNDK1wPUxvJ5ORdb85KtnHlHf?=
 =?us-ascii?Q?JTKE/E4clJNFT1OYSOLRUno5ZWvJG/WsG59FYyHQ4nECtSKHi1AaDVdwkEWP?=
 =?us-ascii?Q?sPKMYc092ixJmFOAf64iPU6xIS/TEobx3lAVg2IsQVfSa7ehOI2Bzz+7KTfg?=
 =?us-ascii?Q?w1MchKOpdPntfdlZE3wWNCtzAEMGTwEZYI4xD2ei4E/GyCcBJ0h+kgEIyUOc?=
 =?us-ascii?Q?ivknn9kPa5JvBmYA8xNX3oM3+RSb51bGM1zq1/8ioLq+TOy8P9lCrignpHlS?=
 =?us-ascii?Q?2GpjnQLApKvZwKIttXFHhpcrljesdA3YSrs8ZJuXmWfduxc5ruFfa0V6vrJI?=
 =?us-ascii?Q?A0eLqCkHVHp8uMLassKGKIRj3FxvrMjVbNsBg47zNn7bPcnlvK5X2KYlQvWH?=
 =?us-ascii?Q?s+5WA+IPDarBwJdJdFkoww6iKG5Uavsv1yRc92Tf0OTPhO4gCMdRF4P32vEe?=
 =?us-ascii?Q?xanoiuFDA/j72sBNGQgTnNGTwJy9ppWC+qQZ3tCISUvQ1XBaOMN/nVzVx5G3?=
 =?us-ascii?Q?ZArkGjnRCE0PSA6M7F+z5bW03c7fb8W9Q6UQIWHFc3AhceSXcXxtclmCsEft?=
 =?us-ascii?Q?syOYXbwmBg2YPDTJ9MztuA73PjkylcyWqMTGIScUkJAtWHqY09vOXdL0cObU?=
 =?us-ascii?Q?M7GIKd1PaNiyP5mtVX2cy1FAHpyBhHJhDkgp1KeT65hVl37w4SEmi1SuUINo?=
 =?us-ascii?Q?My0TTrJyJMfZayM9dKJq7CdPBphu2CBZU+XAtacupUNbW8MT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279c84c3-f0b2-46d8-5f0d-08decc87be6f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 15:47:32.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epTTsn9hfeYNbfvVmWDBgqSYtIFT+ATSfRTw7qXdqwJFdIoN32XckY5R2F7hIHol
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5675
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F11AC000E
X-Stat-Signature: xhm3xuc574ys4eoo1r7n7hqywpanptdr
X-Rspam-User: 
X-HE-Tag: 1781711259-268502
X-HE-Meta: U2FsdGVkX18sY50qEQoKiVfVG7ArdSjEHuWGRJ6VuwAahYfxteDhYT0Ci4KLVj8B0RVA0lnhBo5ilstwP+SpG/cn71M2ImRCFNnfC+8rshuo0+7/1Qh/MRJhqNpf4P3KSmE/LYRstBFzqpYg8FIGyynnoLUbA8YB2jEG+r7dm/tpY5NqJ1dkDtriaoGe89lyW4DlhvEX5Q4UwAbKVygjF/mioWoRiJ7H1SYNBd4BzHR7a28X/LnrVgiyPtlOYAVslpW0nwtF/P03phNiu1/LSVALE1dfPJ41kamZc6EzA3Jyinr29K4AZkcgqRYkHBmfDkRFQn3RToPGs3u2DzFvv9GyIw95lhw8zx4NIq4ViqZP2zb+WMu7hMiRBWD1GEXiDIw718EF+OSVqYsxAyWUKySRnjDV3Sy2gb++4ci3LU5sVaRjuRjA6ltArtoB6FK5OLYsscsZX/RQDRWncVMUSaIZcw6LjeKej5H7pjvMle1Oe8OVzIHCCdoHyNq5mKuiUO2CPW2KySYTTkSjQNipoNgaMwowuaQ2y+bM8bqzx5IUlms/JRSDdUeqBGs2OnaAuZkKuVmhqAu3HHJARfQMfCll3sGJpXq5GLeSte7ZCKRdvlKWqQrnLiZAI0oiisEjzmeNfgtNvECvKJp7SfyvSNrl/rSc3MhqepCQK7s6ADTz7prIBNzrgCXK7nZeb9Y6grcr5Yi/krMp8ihq+zhbsshutxDDf2fF8q9RjjCkN+Zz6elVwWrsC7trC35i3Y0bCSFbQzWsU7blZkWaq9+tXmH6WCPzeJDdjq9xstg45Dgz900GxuRuqO6bEIgtz/EqDM/YQfV3Cn3grfG/rXIDmeuO6RfmYVkqv3YoLvx3cLELQCBuWZp9uFONsvzMYjiRCecgmX6BrwaXrIxm+RzPlCjgVi4CzHimKxZC0dJ0b5XR1qTM+VnHbW0hN5PxqgPz+pDzjrdZIp2S74Wni5U
 yeb8kreX
 PyKTn2MpYG7VP/fwCoaUjapvuD/mlaxc9psvRkbUSwcOf8y30y+KxLbkVrW5Q/c0kiKtoT+7WBzvkw/qL9WnuudODoE5AFz0K6SR3nyHw3WcdXQWPckIswZKwv4bc3a/brO36DOl3qkRule/dC5hxyQ6tieXdOaOOBGFAslwyhaVCSDY+g+ikA9Uj3TeiCkCYuB2ZqJKjOEgotxhUIHKUkXbhGtmWGhK1cxQA1QgEvE+NfqDdrDi5NH8KjPhtpn8XWMek4yRXISwkwByOd6b8k+E4fvypLCD9VA64GQv9Ct/97e1tMrW4zrejMAFnUQHEY9hQhIzzYDFJPSVvQloFeOJB2RsCAsf/H0j2QOLidh2yYDT7+rdqul35Qc+0IkUcgbWUzeyqjre2SOw9htSDVSAVR9dLawQBT//yW1IbrKXGHzyvV4mtE5sA99lxjuLzm2oOqh7ITF604ppHu22MSFvNF9ImvXMr8qWpAGlVkr3zUKTfwQc1hNtSR2XUMkVDy5su6aZ6gH6Pal3fFh2Zp83EZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Jun 2026, at 9:27, Ben Dooks wrote:

> The vm_numa_stat_key is declared in <linux/vmstat.h> but this is
> currently not included in mm/page_alloc.c so include it to fix
> the following sparse warning:
>
> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not decla=
red. Should it be static?
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  mm/page_alloc.c | 1 +
>  1 file changed, 1 insertion(+)
>
vmstat.h is already included at line 37[1].

I wonder why sparse complains and why adding a duplicated one below fixes=

it.

[1] https://elixir.bootlin.com/linux/v7.1/source/mm/page_alloc.c#L37

Best Regards,
Yan, Zi

