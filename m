Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4BAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 02:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1125F6B00AC; Tue,  5 Aug 2025 22:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA616B00AD; Tue,  5 Aug 2025 22:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B196B00AE; Tue,  5 Aug 2025 22:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4BE16B00AC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:22:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B63A7160374
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:22:28 +0000 (UTC)
X-FDA: 83744733576.26.ECD5633
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04763C000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:22:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vl8NGN45;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754446946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwxGKTJlw93Fk+fMk4JcYsQHDckAlvBx2OE6ha8dvPg=;
	b=umzbHK1OywxyYqPXxuL6TUKdrXABk5DB2qvyZCAUusUDtVEvovGSEIBp4ECJHlJSHNB+6H
	84UaoAjDvHNLCdtXbNY/VVxACoOtffYB50DRKvSrz1nL/m3nBC4BL4t515iGPSJJuRyEAR
	+s00H4k32KyKdF+96ZQXLBqBRdhLwEc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754446946; a=rsa-sha256;
	cv=pass;
	b=SKuOrd69Sb37jVAI14NMKFSZXLC+9wcoVvxUpMd/8f4utJTmncmzNsXWx5b/NWn1B6kL5j
	a0TPQu+FZsRFlFbEznjTucjuth9lNtNHbbeC5n+sLZZGmz6GHAZwJsetTEQoJg8h31RvGV
	VbCo8+hv2trSuZIv2Go6bWvPO/WdwQU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vl8NGN45;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtvWMlqkO3IcyUzNY5Dyzz3cbOOOKQlGp5LQUw7VBz1xlHMg+Z1J7dOSeB1UX5DXCHW9x2FG804fI+LmTA13yfbY1QY62fsnvpu3y+w4mSHVrNoXXlf7xU19QFg77BkjLWBj5ouJ11L/jpRvB4kei1cqvQW3yqSV4LetL6ZY48AhtO+QV7XbhqiHDGtcHc2omxbDtaOM1SSVk0OYw8B4lAb6fkjPHtngl2KE/JgOD+AXujbrUQf73qVPJrCCtHbXI0vPLf8wtIDNPg1nrMILbPPmQ+7EvvQe+4jlsGqCpHRqdxD7okp2tFRSAamnColvakiJNZQwYshi5SgZPSkcig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwxGKTJlw93Fk+fMk4JcYsQHDckAlvBx2OE6ha8dvPg=;
 b=ruAKQeHDZ9uc2PmdMQlLU6gAz3L2XpaWPsCVb8J3HdRAAN2YRmR4lVEJ3kYlDRCyPwJhCyvkwSwiqB54HAPh+B+3/WmL/pEAu+CyFWmKGq31govMoE7ofYiTrPuOJlVXcWd4iVYxdv1n/Rr7m97/Pcv8u54cXxfhzpYAcHXq/DzLUGdUdaFRLwMZTFkVTXkrsvM7YJHIxf/2qE0dIAKSjNuZELO2TmPngdDgry1gt4LeuxCI4QC/u2OiScKyv+ULgX/yEvLbq6odkyVULsHRkIHNxE4vWkb2Bha2Xm4a7693apm8dTcQ90tO4Il6yncMbqBybijWBupDeNnW+Ecrcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwxGKTJlw93Fk+fMk4JcYsQHDckAlvBx2OE6ha8dvPg=;
 b=Vl8NGN45B+178bWRK/ttRTS1TV2eeNYciiTjUpccgioY0IaHby47iGjgBZivrGGpnBa9Vy3Ui9TG5W9TTmm5sdRaIp2ljo8jbvvlcjweMc/BRdOda2eLAFyeO10Z/HE1KquPs1+346GtjsiKek46Ak6rzKdeH8lGDzS+2+G1Kqx/oeWE/BbuGA3FauYXaZh2UI/QBUOuYSlOpUNewO+EmcCLekmgvjPO/6/7H6Y3ev81Et2EWPs1D0aoJLv44G+z7GC0aPOKG43RgqVeXbT4NPrqfRAdeBKSFFTfw5zoZj77jnF8sbBzp7MK8AlkpPSacdFN/D9bLJJwXDB5fWdecw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 02:20:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 02:20:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/4] mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
Date: Tue,  5 Aug 2025 22:20:42 -0400
Message-ID: <20250806022045.342824-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250806022045.342824-1-ziy@nvidia.com>
References: <20250806022045.342824-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:91::36) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: 46f0f364-0269-49a1-c914-08ddd48fdfda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2iCOIxamJ73ogeTTj5+Wib+iSch35YQOEuG0/vgldzVOiaO53MaHCZqBBHs6?=
 =?us-ascii?Q?V9vGbrliFAD7cZOcRkA6Lk2mccB3w+1F4iWWVKzxdSxbne5dlj3DVtj97sqV?=
 =?us-ascii?Q?9K6VuyRvu+SB1/kF0wETBzhXC90dmQ+OB6nB3F05VQpOF9nKZlwLEp7b9kgV?=
 =?us-ascii?Q?eAuTO8srKt986ma4ALKZtn0eF6etLcC7P5IEyNx0TEzpbyP0MAuHFvernK0T?=
 =?us-ascii?Q?BIwXrHNmuUt35rZkkMN7XgvAAFDLU7RocSAbJPI/v2ErclArtnSGp8hKFvCh?=
 =?us-ascii?Q?Lirpb0AK0yU8LZkUnojbvUmEb25g5MD7Dxd95WKmH5egRtW+0IXQ9ufCx1Wk?=
 =?us-ascii?Q?0rP+Jjr32lfDVgtOyEfKmv/VtmVwLm1a2mohJf0hNrbjMliWEb+t39e9mtA4?=
 =?us-ascii?Q?lU/ZKHbqFYtmS1bx12F0IcQfF35bI+RvhyZ60zOuIyj8WezXNruDV6Iliitl?=
 =?us-ascii?Q?+8OJPhZEUxpnZDOEICQW0JeMh4TMordw/s8OzB4eOs/b9QQsJlHhASk5OMa4?=
 =?us-ascii?Q?a74ts+MTMrzdv10WIyaPpX0TsOu1+I8lBvYRp6mroidoNdoUxibzHourrbWo?=
 =?us-ascii?Q?mIz7pmBSNZaZyRRsCUHZXUQhp8Juwk51dsLKpbfhTaZpvjoEVs0yp6g7MQYC?=
 =?us-ascii?Q?I9n3MYd6ocODGBvs4fIqng1cWxhnoH49lTGnP6w4ZBQLTKdTzwLveMuxvfsE?=
 =?us-ascii?Q?2ax3mn7z+AHdhOvWv4UNJGLl5kMEFvCWbXBzlLCh81hkozjvexzet7wvbxVC?=
 =?us-ascii?Q?1AjgWqisTKAeP5QBUny5h5wa47Gz/nWcedbZ7ac9ISHShXyqnpp99Om4c4/t?=
 =?us-ascii?Q?/tSYeDQF74i70/in63aRdi5IudM1NsUWCk05ufYRDREhevEVEmAFKZGH3KBm?=
 =?us-ascii?Q?H5pT0cDOoCPej7uZHjjLOtrDncVDPkxSJVzk8mEiO+7tC70qKv+dVNklZQa6?=
 =?us-ascii?Q?rjiJURXzxS4E8Fo4c/kp0JZ+jOq3YIY/rGlfDSaim/SV6nnBm218Mze+Sn4l?=
 =?us-ascii?Q?Z4EFpjXVxxzeEUjQdAD4JsDAGlZ7Mdi2BeyDlXTc7Kmnho0CIyXXE+60C3Nf?=
 =?us-ascii?Q?oJuXVyTi0NZNc//cXp352Xkt0o7chvfqjR0OTt3KN5TjiWl9YNWtzhPHEmp0?=
 =?us-ascii?Q?4MedXfmLTCVZhYj6QXIpx1f2smPDidb+GH8AgXGqTf8piKw5uEZ4V77/HUiq?=
 =?us-ascii?Q?Q1nLmEydZ27AQkN06PJNfGM7gXAgXmc1E84PKSUAa3cx1/XFD5w715V1+ToO?=
 =?us-ascii?Q?CkQ1wzjHy5P6g7RXj+Um0b0fmkiwL2eUoMOmiaUVKv1ycJ/oixThmxkVBf2P?=
 =?us-ascii?Q?a92F3cJckoqCfvUqodXNBgmsLrRablkYcXS54SvThMnR8aNNclrbsCD1j163?=
 =?us-ascii?Q?Ly1uxcfscRXLVb0YqBdGjNdzUy7AV7xkK+aFYpOyqh1o8IKp8vcBgeb8pHAD?=
 =?us-ascii?Q?09/i+UDrsuo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0/xeH7Ouhf44ynruFJf6aqykOoHyAXvlkms76AvvLVyA1TsyVIbEH2vHzTpf?=
 =?us-ascii?Q?7n/b/oHb5BJ85fNsualQEHZdcYfYMKv5J2ZxOs1fgOehuNWwomqvs0LiQpgk?=
 =?us-ascii?Q?Pqbmzzx7IOdUsL/sUWatwzvi2pIx6AFg13i3t+0J+UYZqbW2k3ulKjCwCNgM?=
 =?us-ascii?Q?6wytmC08NRmwYO60GweSQ0Ahhrhw+yTG3AeqG8Y4un1DnFHm6XglCrQKt4h3?=
 =?us-ascii?Q?MI4q3b8EDNqMY0OUcD18QoweB6U2Sev43y3eKuscsITDCr5xvIoxq6TcTI5f?=
 =?us-ascii?Q?DjxUAYOWsedbhhIVlva3/Zj5t8ctziK1Z8V/21a17EdaL1WgNQd3xBFlB5z/?=
 =?us-ascii?Q?N4hewIadsAu/QxMIZ9/d5JPWon1rj5o4mbWlfiXfV07mcVqTOXflytvhCsAw?=
 =?us-ascii?Q?310YtcnDwK1oPV6mHT5cIIsWr56X9Za9gJWCU0+6YsFW1fMw+uiICKuzQtrs?=
 =?us-ascii?Q?B+8rwgQXf6ct8vGJKvIfhsxYRtlk3RNAO9liCj3hEU4cLjyFDaOC0Bp19rkZ?=
 =?us-ascii?Q?W1hsNk3BQMmljzUdGIg2IJ0U/zFw8zEcooiut4P35tstVyvqlbSJDz9Q45Ch?=
 =?us-ascii?Q?x8Y7GSUl0TJBKXPfUVNSfvRTuq4rrPwKXTy4ZygkT6m1ZcNmPKTLtlsUcQOo?=
 =?us-ascii?Q?CpD/YbjvMbZ1q96Noa4XRXRjKFFkgvG7NGHBMVFZ5K1mkUPlNShbSBzCO/41?=
 =?us-ascii?Q?AN2MGcKlJpATZ6guMsGEV/rfclx7A8qHsbw+9jFWFO4nNnhFzI9jWDfYPD7i?=
 =?us-ascii?Q?6MRTXdGbb5jAe1qpDYjFaGHF6fLGSt2YxbRgqvStOpUC4OUX2Uc9zg/0RC+d?=
 =?us-ascii?Q?PNw7Zf5PlEIQ+57JFjvG/MQgUz/7AZhbJmYZZcE8T+OZ/HDMZH+XT4y2nYEn?=
 =?us-ascii?Q?/G53d8sMWcS3oYseBFRfv6oFa3bMceXE4cg/KNnhRE45Mb/SXEOyRiE1n5Oa?=
 =?us-ascii?Q?O3/gNikmB/4ddu3a2pZocxQrbzqVtU3+RkxtMn0PLCDwHm1vgbW0mGcz0b0R?=
 =?us-ascii?Q?rHMhcotLpme7WTnnroTDAaT5EeMQCYqnQgcMvo+Vihf0qHPCxD1SsRH7m7XI?=
 =?us-ascii?Q?/uEY2YtL9G4Ptr5XFVBDNIbhu2UPy313hHfhYMltnS8/AXmfMXz8jBrnu/lC?=
 =?us-ascii?Q?vQJL2XoesYEewQbAjR3owAfRKrUZobjf9/PwzGhvyjM7C8L18xoC1/bhVBd5?=
 =?us-ascii?Q?6CklrPy+uJbB0hUVRnHPh9gf2duo2REeqhj7YcLMrCmNEyAwQIOKTV5+tXrI?=
 =?us-ascii?Q?B7OhgObrqPhbtDiWFjJ00+qLBGF+g8l21xn08YoKQM+MwUPhakeQ97C3Bz+G?=
 =?us-ascii?Q?hXxX0MjHlA2xkaG9tJuvZzaqEA3lIHTTqjG+pkFLDMjzHVaIyH4XKETJqcYv?=
 =?us-ascii?Q?fu2+ODTCVjyw7nVc5eVAEFoYc4r5UBSGKk31bO6NMJgNKNJTgvQMeBttz+Vk?=
 =?us-ascii?Q?SLEtApF8xNJ+4J4ftL/FC+SmpS+9LUP+AxJNrfI5TKAwbZyxkyVled4ozvtq?=
 =?us-ascii?Q?CsjzpoJtK4eWH8cXoMGi/NQHFmIxWHpCXf2yjEE1Ibg6CEHSbYdMxLCuA5De?=
 =?us-ascii?Q?2Q+C5/nvTgYEywEyVd6Xjb9yR0P9VOpqMGZExThN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f0f364-0269-49a1-c914-08ddd48fdfda
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:20:55.8651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmDZRLQDezS1VhlZhQYRzceTPrt0pElgcZQZzja8wxo+pfYKr8eH1SabjsM9SYSu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678
X-Rspamd-Queue-Id: 04763C000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: hybmbqqqoyt7aw81ebfi9geetwmyodo4
X-HE-Tag: 1754446945-970113
X-HE-Meta: U2FsdGVkX1/J04sRhohJjyhMAdi32Ap1HLgdR9zjpjUr7SLFOdG+WwhnqmmH4nYc7Hg4ELb/gcE6wcLj+86cAzb+pyRm5vHgg04G3siO3yPeZ0LkRzzek+tuROC4wjBmC/7kvQslVwVKsxOix5WJ6QHyB7vgZFwgvtOQEV9HAVsCHosqEQK4Ja/OPINriybwEtsp4h3ZrADK1n1W0hMLccIFSJZ7EK7FZv+FRYE2Cgxm6QV6vVVoZrEMEakDAMX6FaEpWNjyd2pstlTWbqW4+d2LmYngdgl3G5Z7SFv9E9Wjdc240o4DGwiU+eLI8cTWvkeO6v/BIbxX/gyW186QdLX0j8B4nplVt7Nfi9MIfiBQuqo3seBqwT1LYGZcdx40dgsELGOC1I2F5NoKl+UzX1H4v5uDtnsslWi5JEIo+YLDphBYVZcSZPyG1vsAtGlHTvcx6sIjMjXCpCsfu0ZWARfaGApaWJ2h9ge6ahNq3/7ts711UQkCoSPpPxc70VQK4uovTXUrUER/USBSpnYfniTUrD1V4//mwEogAp73vxbCwNuJaj7KdL9KPDYvn8/3cQeOglpIN7o3bJwKmhdLFvfFMbnuRAhquKvEzuB5Y5vmP0kvswUNXdmUSpg6sf9aD96UIQaV8PYWr0GRsREbw/xS4uyqQU9IRAgQ71hCFQ/c5lw4rCj/+bxjKetEDiugFBM6pJqi78IZH82fQGUMzaE/MqztmyDio6UovXtjoYgmYukWf/Pxd9Yj7YOVAspZ6aAmrI2D5azdLZ7tYIgiWfK3N0KNOFSqYGSYeVS+cY+WG90uouY09wkIX8bbhkbH/Qs2+oewwZSAmMDYg+p2dhFMN+qx0TiV3ZAdkTOAfbUKMoqLIa19KO10W7tYcxnCJgXD84HSHEc345mBlK3AxzZuThydKOMATWmT0CqhCH/KFTaF/Maq/LjziP6HTIXZENhB0gLQl1CYl7Zo05H
 iq6UHMRY
 r2RwjcidtmMdnotWHvBybSbGHJ4/4Hvi7b2tMHmQ3CA0CPfF7jDfiY3flw4DfTBbC7ZdNS9ewLdifeemBxz9nGsx0aILMGhK9dgf6d0Fld0eQyhziNJ72IbgqCkw8c1VkgwrhVVHGvzo/2ZwyzC9CRP16cS9HXnTXIN4xcV6MtwuCZnyzjJIHue4uhVgdbdjNWAHW6cuT0/PdMZEw11WHyuKipLe1Y9PON6V25TFmTHSi1NRWybdgOOkwqAF9FbhZSdNXcn7+sFTcTN8w7v9etVYB/C2GEDU9UetTQ/8HupY/wWBNSI6fysNq1eN1ZHbmjAdiOCs+3VNKX3YpcwYrs0WJzEcKCq8iRCOoaPGD5pQYCpaYJQrQlpSJrWXFevZ8Vy5O7ZFSM7APm5A8faUxqBNjK5Ve2bmS/UF9E2KvOF14P+TdGZuWG5yNvXTrZK4ISphT41sryNXIVV1sicpnatYxwcH+TK1mipwJ69vyPEySmSnXEjvhq/h1noBldiiLHwadFGwlYtg6tyyi/SSgpqbL2qjz48eNoblD+kPJkU/ycZw3+9PQTTOwbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are useful information for debugging split huge page tests.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..8a11c2d402d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		goto out;
 	}
 
-	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
-		 pid, vaddr_start, vaddr_end);
+	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset %ld\n",
+		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
 
 	mmap_read_lock(mm);
 	/*
-- 
2.47.2


