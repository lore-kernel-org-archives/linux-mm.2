Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9CCC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA3F6B0088; Thu,  6 Aug 2026 12:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A676B00A3; Thu,  6 Aug 2026 12:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988D06B00A5; Thu,  6 Aug 2026 12:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 651C66B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:25:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E356FA0967
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:25:10 +0000 (UTC)
X-FDA: 85071369180.28.78F85BA
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22691180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:25:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y7dhmrFW;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wG9L4l8bbapcld5HGLn7sMqF75MvxIOk1oH+BHHVv9E=;
	b=ILt+/FB8iskcjt4sO3LJM6LNB4LCtenYOscBXYDl3w+ZcjTES1JjoMsPNU4LgFI683L1FC
	yAZOzTuQQUjdjBf12Agngsf6h0FSrUM0hTk8Gx0JJlxA7qUzw6uS5tFDUtx0inAwxs8/N7
	WEai4r5CYBex1GpyhnYrFUnK5Hf2ns8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786033508;
	b=IGlBCy66Cg8zCnGmrIeyn2lCVGFawV/S+O66KyCRM30RlfsMERlTl60eIjyYO+LU/JEpzi
	Bhoo/SJRfC66LOi+A06XP4hcmB/iLUTf4TekVhwdMr1wyEdIXRzqh4jeevJvoACawtTe/F
	QWfDuuAEZ3QK+5CJJ0DkinsrCWA4nHY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y7dhmrFW;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dO5CfL+2agcn0xUeVLlkaSVlhNOLy/I1QrfVdkoAI7+JFarnBKYpMPy5O+nWU0RBAFhWoDbfgBlA4B1AY5zBeKdB7/ApKtue0YLXObrxA5TX7Pp98aWzRhF6vVCM8fx32BF/fyo+NlAmn3k/Q7FR374zp2aY47wZMJYlYlvA0cYS7xu1KErZ0M72YmwxRSQXKl1Uej2DUkH5Y7h0MRp4xAVkuBKXVc4XWH0umuy6jsZnbBRpFEiwaMoZdTErYV4ZbVgdyEwhJWakn5yl/1QkzmdSVFCdnom45FGaKc4lznIiuscz9Z0i2Q8WBXAAmgnSocGfHPAMUsdbswJk+cbGAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wG9L4l8bbapcld5HGLn7sMqF75MvxIOk1oH+BHHVv9E=;
 b=naRr5VKIut2pfbXhs6PZKGrnb5wUe+GwJpNGjgCFtakLrTWsVqTZ/c5uHRHx0yCM5LHDHa9T9DYrnCDvlBv3Q7KKQlsrVVKv/vHfq49Wt09jXX3SjMrNZqZup7im4Y1ho12DR15lvpSsSrkZYzJ3RFoJwY1sRM7tGphffPCog6JnHBW41c6eofto1ri1ziN4OCZ26WRCajv7jcstys3dKMeJA0OdWpjuzI+a8phP++CbLXvZid9egLG2u8OCC8Tus5/mSukwdZrbbShzdI83aqljZIShmBcUL21n4UMtgNPkC0w4Z9UkDHOyM0EL8hkywWrkIgUSZk3jsjd481Z4Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wG9L4l8bbapcld5HGLn7sMqF75MvxIOk1oH+BHHVv9E=;
 b=Y7dhmrFWOPUQ7lA2soKSpGNaAbPIGMc2hsLYYxgKZumpmZQvB+R0XwWb+eXXm45eFf3zD8Uk47ODjyEunDrhB6q46X0AFkJ7r3YkJSEuwSCHLnCJ0/vUNf863y5uAhTv6u6Vh5e2bkJA6BwkzmIcHsqMB+s2bgg298Tjex0IOIP4oomJO13TlDJVU5Dfvayjpm7fXdwRVlTzYTlqvwCZ2u4JLttx5zogtVtHJjDDg9b6fn52wxhwGQZHzgUUikPQ99+YEjSoLvx3CxkA0jzKzOiQNnBKCMP6cePeaPmzsyvj5RcnhH8v2LnNgJRCUMkXGkGk+llk90WxKjei+AV9NA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6799.namprd12.prod.outlook.com (2603:10b6:806:25b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 16:25:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 16:25:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v3 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
Date: Thu, 06 Aug 2026 12:24:58 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <CC9577BE-2797-4E51-ADFA-12EB3CF4F9C5@nvidia.com>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-1-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
 <20260804-khugepaged_pte_refactor-v3-1-0364cad642a0@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0047.namprd03.prod.outlook.com
 (2603:10b6:408:fb::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6799:EE_
X-MS-Office365-Filtering-Correlation-Id: caa403a5-3d86-4320-c30d-08def3d74310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|11063799006|4143699003|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	RMWymnKOwaBLotSqUzdfP7Xapjj6j3AoHoJnvFT7tLt3rJecM4Gdr4fs2IsT8z07Q/qMgxNe+C5uKXDC/++FCsXQrBuPYt7887uCGh9TENaUTmMYGtCciyG2TrSrVFxQ4HWJ7XuIfNOeXCCTLY3fb4fWHF5MRu/7Kf8woS7iWn3hVSV223MTsVvezXZ1zAiQUTNkBGWb2xGCVyB+rlKNPZ1s2O3z2N370qeK5knxzdMHrUtl65jjdCEAThSkefilWjBY2YwNSBUdHYOEzS/JaX0n9r23Ici1ysSovfN2ybNvqeX8cPOW0N1dtPtvkjIbxK+lEKmZgS8xyWdpyfhZvVuc9wpIdFT9mCSM23lrBA25FJbaAYZdbzX05/ZhLtlxOMwJjHmlqAiC/ppQt9Lwb2rgnARlA/j7x/QOgyIo6q7xnjXyO1i/tJ01P/Rr7p1wFRWzsTTrOC9KDmVVDE2gCf7QJNYszO5vdNDchWAAE0oxmPJjmAmCEo8QUO+sGqJIwjD0ZwZwhSd6+AcH/FR103BlejNLz3igE2zkKJC5wr3h/QM/CiG9uZRW1OXB1bgS9kEFTrp9nSY2AnIbz/taA9iWCMaZE/y9TEFVAqMtuquGGIC6j4jWbQBXtRh2uSKCcHbWR/fmhJMgOdGaNtH8fQkFFV31A2V/Y08bo4i0Qi4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(11063799006)(4143699003)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wVKQ6Ynx91oSXO/vZX4Qcgq/CHWz2v68G+kRrBlf5xKLeeBCr3SDEi6s+UR0?=
 =?us-ascii?Q?2zXwH28VCJ7iS6T4gAc7eyZ0GHtPWI6AMhfsMIeCvXmAyQFDiCOawF+SN4Hj?=
 =?us-ascii?Q?1k7762MP5zjz/joE+sorSEXDU69fxpiFP9y0X0xTRs3/UvtEmI8R0hooXDY9?=
 =?us-ascii?Q?R5HFtzRb3rIAMX0enfgOSEAAlvRIDCzK+Q0DjEEM88cNxvi7fqgwcK5tSi/i?=
 =?us-ascii?Q?jeNGCAd2OJtQMDTe3Q6m/Hvv0LJQ8Ai8A2oIrHsRkY29abc3jCVKdvCTKeC4?=
 =?us-ascii?Q?3T2IU9Jh2HCwFO2BxqlwlMKf0IL/OttSJQwiPvX2l+9aR5Yg650tnRNyxTbe?=
 =?us-ascii?Q?7+D32pG6Z+dERGHTutK3oJ7PpLjZsBiGlEvCfUXh3YdwYCB1k7IgDxDl7dYQ?=
 =?us-ascii?Q?2PV3KsQlco+0QTZ+HcRXxfYrFeUvZW9Ize9xCnwJEAql3Jr2qHYysaNilkPg?=
 =?us-ascii?Q?j5ri9ZO2GtjRC2byuFeY0EGQ7u84A5/dS8bw0tcLupveqWBcKZ0yPZD8RHCc?=
 =?us-ascii?Q?89ycuyrN73RxgEhchICp1D/HmNsyQOYKfUZCk0we23U0uFjgyms7CLMG+dEQ?=
 =?us-ascii?Q?4NvOBMcU9HE3SN+mVc4R1fSzknHq0zdVER4C03glWlGQGrpd3HFVvumNeh0D?=
 =?us-ascii?Q?jtiayM/TU6Pt2/Ct5QbA6tJp7rf6JkybIUfxjVK1U3ludgpelaR5dCQ3elxZ?=
 =?us-ascii?Q?sewDv7h2ZuleDnH4UhaIFNWCW5s4aFcjgtr/JDO5SijVpxBrpsX/iftp8WxA?=
 =?us-ascii?Q?CWrjZC+8c7S5rjTSxN3CDyYcjA7C+0wWBmkAjSwoGpmd8cYG7T9jlu0Ilbsh?=
 =?us-ascii?Q?hLiYicFkSQVXRMfUGHDGgSqos/JYXfqKLgze3loTRVWfqTlOhIvbcqjQQnXw?=
 =?us-ascii?Q?cxZfUvulJ6lSmT/OdCB4hgAmR8X30eVyApx+V3IJCPj4SqlL4V3ClKZV4+XN?=
 =?us-ascii?Q?veXaFijZK3ffQze/ITUxACR6P50gumIRjkirZw0ZDhhGzH0LJ/dG1wYDMfEj?=
 =?us-ascii?Q?o+77re43g2aCm1CXBdIRW6nkYVm4AY73s3Gygu9Ro5JQ6+ks1iwMMsQ91XAC?=
 =?us-ascii?Q?gikeDi3mujxe0j6cPC9BRCZ5QwfI7SZiV+FkbuDiBRHd8U8O2Vz1g4BqQzon?=
 =?us-ascii?Q?Z/Z1uezN2gYBsDWDjzwmQKxt/7KJv7QAPsCV9tVfh7GB10isEAoEjpxAk1rM?=
 =?us-ascii?Q?i/VOtNygE7YvgD9zLK26BKl/nsHfuRvfHEF8AEGE6ij1seYnY8t4jwTI/hmB?=
 =?us-ascii?Q?YHEhDsw6JtNBpYups1db6rNpsonU9SqUyL6cgJ97c621TWQXXuE/JpVVrHC4?=
 =?us-ascii?Q?nlRO5ZZNgBOJXCA0D4QzYaBt/CV9y8ujpw7irkZEzW8vC7nLji3PD5RTaHz9?=
 =?us-ascii?Q?nt7khPbhDxFd2oE/smedSwVz+f4wv1IXkFVWsM/l+ibpud0HJG9geLIT0Or4?=
 =?us-ascii?Q?lCtZ/4Yb3GKTx5sF1p27+caX0t94xwOQOGp8LifqIqLGtEXz9w8lKRyCdQ8D?=
 =?us-ascii?Q?oXcxsZbRsh7j2HmZxJQv+WMMwbNkUHpwejZkbE5pxiCN6hRVZC8kfktuSja7?=
 =?us-ascii?Q?pTFOTmZJUHNb88hqPqupRmeejYbpPSGvVUQYfUMrRtv68F3iRyRFMUYejBPw?=
 =?us-ascii?Q?qM6xjFdbqaAKS/tKOYud9IZBDKYLT2XtCcbKzhiRKItnO6BXl9N1Bx9yaAob?=
 =?us-ascii?Q?iXB7jrTVnb6nqLE6wMahIAATtksSZkaUcyaJYSS5Yh0JWDvM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caa403a5-3d86-4320-c30d-08def3d74310
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 16:25:00.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Liq7/IQD0F0wmRZ2Z6SAty9WuZx0zD6xJ/8bGssDvqEqSrzFcdAfLu1Yuturk+Kq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6799
X-Rspamd-Queue-Id: 22691180008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sujdqs9oq38ob4nij3mm3occcacet1pj
X-HE-Tag: 1786033507-242858
X-HE-Meta: U2FsdGVkX19O49XuntJD33TN8t6b4WxwTwuEKzazmCc4xxn+MRChEHDdV9H9il+mWmnglVYDQXcYiJDBlRMqpQokfiZJUA9wqJF0DOn64u110dKhtBt6fnSP/rP+5OPahV7z+rmPQLEXp6OMXnf4OD5jtuW1Ri+DzWqKRdJZg884nQSqOqxQHl7bp64PzmUxssYhatFYMun7KQGLFyo6jWF7Mw1AxVA73jQ8Z88jpAIAC2auHOY7UgjfCtTTIhXQNNaWcbYYfZ+iB2oZxQ44sM6+IIx/X0NPGqKZP+tfDX0YtzzbOpYD4jaHZhy6Fbglc6QZfOHAZgKMm5pJlXXPB3TmGcXs4x/G3v2BeCSiWgUuzYv6emiix9sRmWkfGbmGHNK7Og8APAg016uLA4xhSVmlbtvXW118B519T8RXa8q/YEtCE4I+ii9XX7tScsaZ0h2Kq82ogUjOoflTJoJ3FPijYekxEFFBPMVmVvyy7Ml+bRRQT3lh4jOWtcWmleX6nBWgLzKXutpRIV9NVLptExGHhZGNQC+qgAkH2zGGIg0vWlRZBbRIFNjfqRl69D8zsWCCWZ2ahmClkDQolWf4qTkik1VOFFhol6DpFs4RyQhyndozYSvCVXlh4GhV0MdPC2JOh0hTfSNCM+HNYYwnGUqg87qxfZz1pXvQxaZiAW7lGKVYNYGQbTSaHnPHD6JxqDyqIe7p53lfSaFfs4dn4XtKCxRJMd43McNNpdxLP6E9sTrnFpFPXPLKYDlzvKeXhPuIigBSHDvqUiLjKdzZ+QskawiAvpfThLvjX+2WSBX6x+GJO+lMupul+cBAoshTDRssyRs8QPZ+R2nHjq/ahIIBnEN7r3a3RseaxtUJToJznRZoA/VG7tkT/mZ7Vqte8FwHbLALzoBFTCyWggE8LQ/9YQasrTn4B5FLC7JdIo3DEDnMxspnSW8Ev6cNgZPv3ymjX90lnfJYEz4QIxJ
 2cTZsnEe
 ZIsXkQigYPYmxQPHUSl686rUSwrxoPw9MFA8m0dY+hCg8oXd1L0g2ti2td2jOu67BgPMwCrKpHSMm5zU2e/ImlfwHHyYUXKix5YCmEHDF4c/Qqn7ytleq2KLKx/yNj16RxdMtS4skfmUV0bX7DNi74ywyNjk0bVMMTKqaNQMmvFip79G2on/nyZby237ESDil2VlglgIMAusyB70+boXW5woWIQ54fQIon5W5mIY01X0M6PTD9P5Sxk+ME841MB+810Cj7zmfE8EY321wtJMK/864BF2ZgRuocIO25K3iLXbQ0Fsr4aGaw75qnyi6t6UsMTMF0geaFp455sCKZsCNbn2wnHW/joAcFMPMhYs2nT0mCaWhQWXFx4TZ7PrjXOGhOpl5WRe5KrbqD5fFfS2NEWg9in2Itwyc+RoTx5SkR4IZP8tZH8/n+IeZQUrTjpkJjyD0da6flCM2EZQ0E2Rfk3PcJnAC7IUBa/mq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Aug 2026, at 15:24, Nico Pache (Red Hat) wrote:

> Extract the repeated clearing of node_load, alloc_nmask, and
> mthp_present_ptes into a helper to reduce duplication in
> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
> current use the bitmap, they will in the future, and clearing it now is
> harmless.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

