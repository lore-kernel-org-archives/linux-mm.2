Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C414D10AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357286B00A2; Thu, 26 Mar 2026 21:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F546B00A3; Thu, 26 Mar 2026 21:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2448D6B00A4; Thu, 26 Mar 2026 21:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 133456B00A2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:44:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAEB4585C7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:44:06 +0000 (UTC)
X-FDA: 84590147292.09.2C84343
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECEA7180009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:44:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UQZUL3++;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774575844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
	b=n5B0yGqO8jElEKKjD5j9Ebpgv39y0ZYJgC/iJnSX8rGJsE1injHrWM9wIVfmP2/FbriWVz
	/JzAZAReOLtqobEdKMhWw6Qv0auUvvHa1WaO6r/ng0j3w3Z7Id7q/Bl5k9byyCTjPFOdk6
	bGWCpgHI1k3aAoGKsWnN8ghSGwQKqjc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774575844; a=rsa-sha256;
	cv=pass;
	b=2VVfTYmO9s0U8lqv2VJi25dnDPqDPMn+Nk6GEKqmQvokmKBZ/Da5g8O0h/MqFhCtWKMOkV
	/aK/5Ychp4EqUz5d+FQLymqUK6m1j+juNvMIgiwRS5kS2VnRcztEBRVAuK2hNKCHM8JWmm
	aKWlvwrelRvPLkE9L7j6s3oZrcfafLI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UQZUL3++;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rl5xKBTQphUqIEVMfzo0p8+BFUtnH+j7qznw+ghESBLLnBe/4Tc52NRow8qmNyYZNR6tvynL0NKP9GedauSZr2ci/CeqcVra0L6YJtP/qUE8y8Hx3JniVL0nFzVvo1q61/75vm1hbNPdC82wznvk/KWnlwSjL7z76/sIug2rkX5GXmhN2l6JGq1Fcte4Y6LC42nY5h5AYlrIGoovQvSAHtw4nd7x7h9RSysu4aNA9Ojp5etsIdb1VWavq1qKw39Cvu9mfcrIShCZpa+cz1ZetKuiajzo8ESqInU46MJlr4dVx/8L7HXbWEmVF8HQ4gw9NrriIbNGgvRgrGmPH9T6Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
 b=iyfSX4qho/jeMc73JvYJJ3nVhtHeXOtEwVO129oNEdFCu7SnlFwCkchW7RpEo+655pDOX/DAzIVn3mSRGTFUZZKbuD41IzKqoTeOO7sWQyoebL62ddfTopdi5nv0M7e/KupvMRd1VGYtbhRTKY9oZafzqHbIFmhl0QW82xK7d5O38LAAG4YzSSP/FATZoAlQHSvNpRmq1BDrjxfvXM1tW0nnhmZ24pYPATe900TxR9AsaWwbH3bf3JEzaVThZMtpcc6d62sEhRGdiyvDiB/vqTGUAXxRn5VWrz0LXmkKDxCrwBwVYLLAqbFgAR13to4eUEFiaXmVPCsygPKLrhuXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
 b=UQZUL3++YQ3NfvMLOvwM3QbCz6BslWYDcdE70PGm+oSKbLgR02fFOtUOx83Sy4zKtXcW3M9N2YwYBGPGx01zOj1EtuxOgmXCk93bA2HNXSE9c8qA2qIhz586bBNK1X6VwK0GJ5rSu04Lfu0qa5ax1oJ2yzxGbiNS48OYdX5ylb9GMgMei0UtolNsZA2ORjX6XuG00K+b8LmmNMlIb6PonNt58Ro3DqXXNNmxQe38auh5YBISonYF0JzsFSPAu4/XVoyUJOIMnsk2HjjmlahulvHvJ1yKVWIps0D2vMFuLH4NDzomJGM5wpc2l1pK50jwS5Lqua7yxgHHxLRYnQFI3g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v1 10/10] selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in guard-regions
Date: Thu, 26 Mar 2026 21:42:55 -0400
Message-ID: <20260327014255.2058916-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:208:23d::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 312556cf-704f-47c6-b613-08de8ba23879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Tk47kEW4NnuyyTr4m1HQJQUugyodlLPp7btXs9+EmtyRZ9lEnXUezw9+JTNc+9hqy5yOlUTV2qlI3G873eUlVK8/2Manmfvi1OT+Q38miPH4oUDWu4suH5i31BZiVJ8a7hk5qFgTCSHmxr+N+e11W8FS2i/9XJMEyd2RBhzInt0Z7vc6fLmiMERoB42d5tt/g2DsdbGnauW3Hl7+BO0DYeRE2aEG7+XUYsEGnH6p7wJzcDn4PdImcNe8y6gZVOHWVRP2i5kiFxzplab6YU2FBK5jQo8DIKLCosU/K0u8sZg9uKfnMUShHpH5IfHgy1ao0pIwTrgeAgu3az2Ch22BG/Q8rsbgWrN/rIjbdicAX6R+o41VVj8C/H1JumgqupSTNJ5f/0hPlNLlfy0qmvm5gt1qhB1zdSC/L99RY1FJj3gP4GCCex/qJOCUOXNcnmcN+ax/37uoW0SE1GHjQa8u274nYhS7FruQfiyzl6GDDmFDuIatYRVps8p4DvDWY/GkbEeVp5yvsNZ9e8aunw6pzQCWGR6A8QamQWc40iaUYHuYKYK76BH1cujuWDAOYjjwE4uUmga7HBjPPYeH/YKT4IHHUD/lLADBJOi8C1y5albEj5O1eSBHaSfhEUZUi9KPxHNNIQh2Chw/HHmurFtJceLWwKR1A3I4g84WnsQPjX8w1ip9dVrMZ36YW60LW8AEhX31Qy/7aQHpJIWxpV+YSFc97V4leJIfm60OHchbPbs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fnq2hejq+/u39/bXN4tmzSNvyEbwf7GeZXbrXJ/aCIYO2EQBvc4rulTly3iU?=
 =?us-ascii?Q?cFlM3fn63lrTlaUlFlkBkeN36ke4hn67ZM/pDUyj9I72DWtmxDWR5Tj43Z6F?=
 =?us-ascii?Q?dzplQ9gmEc5IsXSF40n5srCJdGyX8rDTCQ9ZdjLfkUWLJD/LZFHWPvyz5o1/?=
 =?us-ascii?Q?vp51ecwsw7mkv12OAqYGLr5P4Nl2Ayl6CJhlKQ8l9qzSdajLm5aomvurAuxx?=
 =?us-ascii?Q?lsJ9njOulkRIiivI1AfQKd37yMoxmiG4ucOFcCc1BkPO2XthulaeHa0YEqmw?=
 =?us-ascii?Q?KTb3ffe9Ow7tlomm05J0nCU7fDcK6hsEfF/uIpUeCAJpYfnQLFepmMq+LJvX?=
 =?us-ascii?Q?/dDCCSsZ1d3hwd4d+lafWk10tUVZkvldADOSjEKe6PlIJausvJ2qiSp7JXzT?=
 =?us-ascii?Q?vZdKcIsDPqCPoJxytmIz4MBl1FrCFga9ERZxjsLo24S+GfpQTGoVHuFKt0+z?=
 =?us-ascii?Q?5K9+RoswTNDdtnvi3vADXIJmPzSeEn95Pw9Qb5+/QkHjIOkM5LxNWxrOJaFF?=
 =?us-ascii?Q?4guhFcAJ1uYLUdekZOxuvIqFRJEhgb8szHwZG0R5bKUnni6a4gNSgYRp8eSu?=
 =?us-ascii?Q?XJ0qqxLEbSsCGYh8BF747W52EuXE0VqP6tkMmuWIeWusLwE7h/nunU5dwbax?=
 =?us-ascii?Q?6hcCHztUx3D+ym7DY0t3mUaI8Im9rbHsdb6HvEtd8bRCdOfyMsngUuJ++xqi?=
 =?us-ascii?Q?REvtjlLiK+rKAaqSsOl3sSqYUOLPGDUozDmg8d2H2CxbZletIfoJti3jDOCw?=
 =?us-ascii?Q?0fz0TMYclpRGRGYD7KnVTkQb5e+/Yy1+sAdpl8XAEHaM/2umI8yo4vijInhf?=
 =?us-ascii?Q?xz2mIGr9WYL1vIow/jmQasu3KW8XdmgP3yOGO18IoTCDeKfReBMUoXyn7i7s?=
 =?us-ascii?Q?earvUhSKXl9wE68P9B36n2w5P9+nPQAVJE8XpKt9F0qjC69hNmvdzNHW8t1j?=
 =?us-ascii?Q?7SgV2PyosuIARkMm9/+ZG/tEVWOuVHE0udNIIHVpucaKjlvLLeieV2z4lE2k?=
 =?us-ascii?Q?J7BWrSGzlZm+M/puw4rlK8ZfDtC2q7To+fk8cx/LE/Wcye5ZrwA6YkOEGWrO?=
 =?us-ascii?Q?vxuF5TOZA7Ebv0rz2f+gmP1UerSvWM5/JPPpp95qtmvX/qJHNXsN0+7+DeW7?=
 =?us-ascii?Q?kO3INbdTWbUvj4fTtgNMbnuSZwKew9/bWQYK9YbXqc8zv3yaoQZ0cbtw0lqY?=
 =?us-ascii?Q?jMRCE34FMlq0v7Vwixn/OSypDDLjiUd/vExKPiin8cvqrV9w44IgpTQhyLDl?=
 =?us-ascii?Q?5kel3earHl98HahgtjdKgVDp/rT1ODL+3pZ7EbAOHiCda6wjy1QBZdOb+3m0?=
 =?us-ascii?Q?K+pXNTNqsXXOQdKTxLbH4D3RIabU+leq2uBkHuknHoM/KfF73uwky7wy/9qU?=
 =?us-ascii?Q?cPujYnDOo2PLaStKCg+GR81FgWl4VLlq4oK26u7rjR48Qn2NCruDcZo1VGiW?=
 =?us-ascii?Q?ngSfySlFGmuVR6P4zECH4d21vZCzj2xy8RjaZUklL775YLWAAwpZgsNB8p48?=
 =?us-ascii?Q?ClWcMhHoTtNr5fjD2d5xE4qYtEs3F+uUtIJf4JooVkgtswKrsdNcIGjqfcJd?=
 =?us-ascii?Q?AbdVXuAb+lRvSLsgv38JPcHNV/xo+/bG90GLQv1GJnN50DVJ44O0LdoBKXZ/?=
 =?us-ascii?Q?eJPwz5/Ck/wBPcLklGVSopS5PlP4menwOuMMjzsk6MXkeB07b/q7IUY1WbeA?=
 =?us-ascii?Q?sApms+Z52MDL2NlsixL01EqiMEFWcbNLsX2aQjUrRsjQNrYN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312556cf-704f-47c6-b613-08de8ba23879
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:18.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UdKMNYytQ4Xb5lYWs+/HtvGqIXBwmQVzQcyiycwtxGfxExwboDvXD8CokPhJzpN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264
X-Rspamd-Server: rspam12
X-Stat-Signature: rde7dzaf5j54sbrfzidxfazns7h9736y
X-Rspamd-Queue-Id: ECEA7180009
X-Rspam-User: 
X-HE-Tag: 1774575843-62130
X-HE-Meta: U2FsdGVkX1+ppqaoXAMDkIJCtxvuPlXAS+MhLj9cUipoI6++RiwkPVAXZusT73KZ43bEES3y2tidgfre/bPojwhlMPI2kBywQJBsGw06xeyRoXk1/S0fSXYhTuhYNNLrICdL6oU6rBEj7BD7FTA5XEJq4UQI3rx4P9ndQMNxxa/E+lhS8Rf1T3lvqXGXOhsF3zKXWrXdhtsqY8KAYdtYnc7PiBOcDi7yP4pNeMnPEV+f7kUYLACVTyKaWAjaL7/B5wvwovhbVbCkW8Xk7LQ6UBYaJObBX2BboKdSXKLqJCqaW95EkAsUyu+CKwndB1oJcRHwIapmVl3q7YZeMUhaG8v6Yljj3n2eyFrKv179KclOr1oh5ueidAkinbqptwWYTtM2y0cllaiej0blERipKsFNZfD6FtIYwqh2v7wWhuJcL1gHLF8eQvdorquPUReXO3Emf1/jss+vzb/eFTiBoX5Onk3V+vB5+WutirL4vbBYkn8afJDBTlNNhchEfjEVZrOBAOlcfnz9tstvNmViOQJirctzyZEJXEXCSbi/SRVmIo88PXEaYSN5JoNulpKobBFfutIuSqY0ekEHj4maceSVe+YfbWudKZ9v9CxmQ8SEIOrXnKy3FpJsF8HVzgBauodwmln+mwc23g9/24ZqjWD0UkYjH4gcXPs/J/ZlkrJ60OJnqn7ShRDGlqEBay7JF462URNDNn4UKnDTd9N46Lxt8j8craNwA0MDhSwqB8L/pT299G4CZDN54yRLejZU4yb9qnLLH1WrADWxrIukaykYv+XpoOaq378QRp+Z0leuXEeBbGM+5yBYuz/10YlJzlYWiHF8qpYXkDaT75+elI2ZzYOTogsof97MD1/XmeptEDh4HMuQ8I/X3hWvELS1kv46fRkmA7axi3G3FXwUtZ6vfx4cb4VlTgaDBvo87RltHdxflVhAQxy/oG2jzYoRuVPByTtUOAf/T8zen9k
 Ljy55RK3
 T/Da9G9Xhhr/Y2XWx/KN7O/qIeAuUtQ1YNJj0hWNA71zGydoi22gTu0FwjzV+YPcGHy2ebgKlZKCfm6ulS8yiM84DwdmU6JPmz412vLI/8z2fNb4oNTmOVx0BKvGrSqDX5ZgEKEGVqV9K2hqGE76Wui/iv+yz2j03EHB8ljv8gAEdkvCBhaz1l0H99Z7zwrtSkCYt4H9cT1LHK+zqy+x5ag5FZxJ/ZSPBUur0TvXLcg1Wqs2ki7UU3FecvvASjVtBcnf7rWjMN3vkxfRIbFAsahNwpogti3OI7N9zpTf1xAFFVXIL7xlj/AGDYxDIU+FA0+8GSQw/bn2qfwZ/smnmzkvvYyaqQduQ2Lf+cFJK3YSLNf4wejbxGr7aJxYMYY/s4+xykcX+lrhZZami8OPGRzE0X9fSGtmH1guS+RLgxcgIoPJwz8Z4UvsfAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/guard-regions.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..13e77e48b6ef 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
 
 	/*
 	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
+	 * MADV_COLLAPSE to work.
 	 */
 	if (variant->backing == LOCAL_FILE_BACKED) {
 		ASSERT_EQ(close(self->fd), 0);
@@ -2237,9 +2237,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.43.0


