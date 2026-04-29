Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BF3CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02DC6B00A2; Wed, 29 Apr 2026 11:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9516B00A3; Wed, 29 Apr 2026 11:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF156B00A4; Wed, 29 Apr 2026 11:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 820336B00A2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:37:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E2B2897B7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:37:12 +0000 (UTC)
X-FDA: 84711997104.08.FAC55C6
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011069.outbound.protection.outlook.com [52.101.57.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AA4B100007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:37:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=py+UdriW;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rOk1fhxcOgNPdEzv3fS/AhrLFf76TsrvCYVL615xG0=;
	b=4JgyGhO6Ioorrlx/rwLFXaJney8V/9yGLYFPwOI97Lk/UYIeimGcqDjgm33gOXi41cB+4W
	Xo6fEUU8jenJU4iJVvoXacNrCx0SPpvEgBd9vGY0ITH8tOSE9mQWhKvHoyrzCSRbH4BgGJ
	5xddep4tad1/LM2tA9gLi0gLQy7a5/0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777477029; a=rsa-sha256;
	cv=pass;
	b=GkYpkUyUhxd84UA3IXTXnYWkXvKbxGMWOu6qYwJfUDTfWEwvldq4lF9VfHw5h+F1YtgfB6
	Ym8S9Ap9gMiwNVj08KxvRNA0Z6z8MhvZsAltnNRXKU65WFezg86CVo2HzBl25+J/sAnwff
	uLWlW7YkbHGpEBp+K0yzEnzc8h9TDvs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=py+UdriW;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJmb3MmztT7UlKpPiQNueh7+JIicCOmOvGZJf4MctYqYIw5t3cxZylofyOEjGhh5Yrov2wF9HvY1KAFfHw/MFmkXcO3AduOOulXDZ5zLJ97fK2Ijpj8hU+kQv0BowYmmTluDQeCnnRjCHukoehnKzN44eobTrr0hA5C2/KbM/KOBumwY/6JNuYj0fbm5c47kiATrYScvJMyCt4eibXorh6wS7H0pDAXCJhy3QZwaMbPmKPD+PfrQyC8n6jpAW8O2G/AolRpXWtJHcOptPfIRRQorg3VkAv2MrnAu3mon1VDos8qmKaZWhN2BR21s69mR7MiuC+c4Qb9I0sBiYYanRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rOk1fhxcOgNPdEzv3fS/AhrLFf76TsrvCYVL615xG0=;
 b=pcmBFL+DutMv65rD/xBQm1B36H118yZIrat2OCpumSe9EsU4hns8MVnpS1FNc1aIvHbRKgnEOyF7aijYRWHv5EdFQ1I3SOW4AlHq80dxMfFA1ZQdJSh8sJlQ6XGpVsZsy9g7eGJsuKhzm00suspbyN9B2vwcTSh5zY0UDH+cEVXL/pW4aJP4lU5gtWo9l8DIh/Sci9COsaMg9dyayUlrIlbtv4RyLsDUP7gyeiEbitP8HO1wsTiEZuydMwRrKAWQhD4nlybIL//nMyxPwn6ft6AK3GRaUqIdWxLrqMF91A1ajz/7Of0G2RjRJH0fv/3ifoIZ/+WqtNlFzi3EsBoUrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rOk1fhxcOgNPdEzv3fS/AhrLFf76TsrvCYVL615xG0=;
 b=py+UdriW+tX13tlDLFuZ7YA/zGTOe8u5BMfuXUzt34uxwPELpZV6iBWScmQ8VIj9OKnA3Vz/UiGHiWdmLRRcl3+cV+/6cHAKtnlrg3C+PacK9QdGv5MYY+gMH5iWuSUAin7D62JZUs0LWdbpbRShctQrGsXWmhg5ZA9fNo20HThQeTlZLqU6h9QK1ZKTooUQBZdgTxq8tkTWoCs0IQMxKpaIh38G3N8s9Dc8a8gXjHs0zCJppqOGpuvZ/cAMq1OeCfBJc7HhW0yLx3OMPqCVx+gJ9XdWafcdWXnQA6vXSEAtaDK5HuNvZutzBMAePVe7kvbjTWmvl4llEljLqMpfGg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
Subject: [PATCH v5 10/14] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Wed, 29 Apr 2026 11:35:33 -0400
Message-ID: <20260429153538.727855-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0358.namprd03.prod.outlook.com (2603:10b6:8:55::7)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3ce1e3-f7ff-457d-b01e-08dea6052200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UHlo7WuvOsPN2zzWzEYGF9/vwL8Cq+3Iz3d1E9OGvGyGHN65tUYlKDiPUrDmpGedifkVTJo5UtlXF18eWZ/5W0ccrc/99QxNUsu8QWMScOXCuHPruM09CK6ta3bHSAaIjTbP+W8MTfbkDLbiU1zfSh5AP+U/9BFCH4vkmwYwd/RzTlIzxfeo8ybYY+qX5xFqco0uq35Yq0n5r5bXQtrvk58+uamlLoJwIWB6i7WNMmuAFUP+pztwIMpcCGwNlfWYIORszqomMveMDHgAsnqaSlIVOSlhcppF5PY6eN0bKMuHxBS+odobVTz9jqQtOih45Xjn7UyTCYGApgoZ8A1wocKUxOAAmiYydJngE2VKFKtIHGDEZ3YkI47r66Y61qJZGSTZG9+otE6k1MR6mL4R+OarLnnjRtt/7GbUdO/DlifbpKeihWyrMMZZJC+Q7bk7ZfBNYc804q+d8O6O7uEnJHq8dJ2JNn7ZrfW7Cj5+loCtzBEzQ3DGclQEK3VL8LwyA9AZlspAJ6gLbp3O9BL4VQNQAOSJ0Bfy9PbYGgyIgH0WGNvsfWKt3bgQX677Whl7KOkfWzI03XVfoitxUDHjdQADMlg+N5UQwBulVccLZXN0sj96+LjSX3E8KhnzemYq2zY71z5HUWsEqyrslabJZc39ARHPNf5BorViglu9P5DQEEavd4MEZ5eezQaMHfnB0IazUDnYRQ+C41X94mlHNrD5iwgupSzl3/kko4xXe0k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F3HMS7q7Ec6kmDVtN3YN0Q6MUBixRhTrzZld60myn+EH5UBCf510GwQWzrl1?=
 =?us-ascii?Q?k/W2AdPTbwzRkVUmqWaSyT4U6zVk5A/h/Impry5bBzjQinhC4thr6Yb7jnWI?=
 =?us-ascii?Q?DxlGcivapuvaV+aAkw3O0/06NkviH/E4nnBkzxmrMm3/9oQ4HEr3YVM00W3K?=
 =?us-ascii?Q?CzYO/k6OaQavZDgZJLmt/sVXDplcxhyt2B3sOmkSPQYGzoXgl563HthQl8zi?=
 =?us-ascii?Q?rEKws+1hioybt4VigC70NP4zeD4nRo7ggZd+fWNlbppohOfHiIRF7jpwex4+?=
 =?us-ascii?Q?XGW1QmZG5GwqT6gpPr1E4xrN9kUJg8b22oPc0vsqoN6Nx4HqyNf8RNljO0Fg?=
 =?us-ascii?Q?o+4r1nRXTpnJRMW2gtTMOAQdRSbZE5vpKW9oRjuM4scU74bKgybEAhZPvaRu?=
 =?us-ascii?Q?4FO9lfzJJ4OjuityOSR2D4ou2cGjib5kOvWieACpHdimmqGQtTTxDYHyLSc3?=
 =?us-ascii?Q?rAQCmaCZ++IiIyJaNjxyIjJcSA8P5j5XERK7AzIQZeWY6hZ7Bh0NOTjJ72H5?=
 =?us-ascii?Q?w43lUzBvACorg/S6zsu6PWlGW+MY2wFlCJYOPc92EOQ5gBTmpR183HUQf6NO?=
 =?us-ascii?Q?vKrVW3o8BiljA8wZBNOgPDP/w5nBPA9L6Uxi3y8jbY3JO58kPJ2H1G9Q2evV?=
 =?us-ascii?Q?sNGPBGsXAEC1+yeqE1F5sm2iAEPZ9ZC/XsBZwKUSNlpMs7RoGHtsRfuwtdOl?=
 =?us-ascii?Q?izsJ9GONQyKtNfdlhsZsHPc8uXRZvHm7ft3sR34vMvXiIYp1Wf00Mjl/Hq9p?=
 =?us-ascii?Q?twln2xq4fJUH58x3q275yoHGf4yDYz7RypJSPD5yeGJZK2smZF+uDOsrq09O?=
 =?us-ascii?Q?nuwH+GqeIxI9Sg102PY4zE2/SjABp7rj8irjxricgfoK1E7vssYKd42TyM+4?=
 =?us-ascii?Q?+qf+sB4imVtHOkqM2Nv95F0F+k9iMZGNTYJAna9sDNkoR4DinmJoNSwoY25m?=
 =?us-ascii?Q?GHf7T/OIFBdrQ8nS7e3dG+PXv/Gi6VpONtA8hoa4I0lgu4X/OuLd/ruH2u05?=
 =?us-ascii?Q?ERepgE2lAxi/xrV2of0akLFE6KU7lb9eWEPw40i58gig+ttDi5SfgrY80P9h?=
 =?us-ascii?Q?uBe5qBDSudcNYOd6cGPMe+MoawKRViC55jz/LcBWGomyGi4nA+BT7HO1biB2?=
 =?us-ascii?Q?VFV8XDHsnKDLnT6mvZQNc6AoZ3UGTfa8GmJeJJlidsdt0IjDCSpbvWRoiulv?=
 =?us-ascii?Q?ne8qY0uWtieWWskPGCGRVOVAu9FaxZ/l2nsw/xKS2VZ4Nh9WlCBS3Le3luMR?=
 =?us-ascii?Q?ONzA2YeVqk9F8o0pI30r2R8rHkymP5s1hWgvqmFmD63eP425a/EVNu2qbUY2?=
 =?us-ascii?Q?UdTNjVxTmZQB/4bhLRFwCYdF5kozlJZ7ibMQho4x2xKjvqvgTDVVl0b77z0i?=
 =?us-ascii?Q?W5gNrb2k8+63k2kL/whxGIrBj+/Bid3qOBxSJWEpVorZZCvo1pzcu55gvR1l?=
 =?us-ascii?Q?RPsfXsVRIBzMlpyFNIqwa1mvthK06HaKX12Jqt/S+vzCFT27j2r0r2/3JYHB?=
 =?us-ascii?Q?VI56tNhs2sv7KcfHDQKKv7JyhJGmYKnPLW+ujDhJaRKz/yOjcXuuOAdzquaZ?=
 =?us-ascii?Q?MbHLlWUG1pzjvFJiDVvQ/CLljE55nEaX3WSXGmU5e2lrXy/YeGtMfF1vXQue?=
 =?us-ascii?Q?Bn5sY6ssTCVVSbdEgQ1otGhYiTCFNYPNbpqmyN1LgbafHB99AWRwdZBb1KeN?=
 =?us-ascii?Q?kTtRVbp0TB+FUxv6isCVBw6WDxLcR/LqPlVD8wOaOUKaRV5f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3ce1e3-f7ff-457d-b01e-08dea6052200
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:50.9591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuEUQltw7lYDSDKk7a6IhmGgfMHlI/fTNFTWiy0FxPy8azz2+LyQBfM4oFPTtl5g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2AA4B100007
X-Stat-Signature: n8nugmom59s3496k9n3f7eceqx46zgfi
X-Rspam-User: 
X-HE-Tag: 1777477028-124551
X-HE-Meta: U2FsdGVkX18ZlXbxTg8p/bUhdVAtgWyW6s96Y0l82WwTjIOW2/Zg87cpDYCPWWQ3P9/vz3hvNues7Ru21CQgiiyW2KVJp0BnjlHz0EIXd+cf+jLW3m7o7+z+mk67TVGYANhGDvDKKGBtIBM63J1SjnJfEr0X4CvCyvfOnC3lcZwGmIEBYXo4iVJQEyky3DlWx8/WTmaorlYrX1ZvVAbfFcofdcwFJiQrrGIY5g/r0SJtrejL4rP5U2DiZj99gAw/eX/SsrOeURYslMkP8Q4AebfW4aISzcaElm9p9qVdkCRtNSEnXJmczcewDtokNPEjXX+u2rm5z4EDg7JxPxqxyPl+FBjnoAgypq6+j2cMcaXwbn/B3MdOHA7DT8VglKeo7wSyfE4opl4XjimdjtUrzsV+Anb91Z+TLIMwLZDD0vlObM3CQQBRe1Ov60ZmfKrOSYZFH3/e+i3o8B6p5YKrwLz1p5ph1QUXZAY32Ei9UtxOHTJjGbzJ80Q6iZZbyxVZil2h8pMUsY5fO0NMZIvCWTjSQtTWoD61zphGDFoHyiiwB1bh1r/DM+WWTxi2zxjkHX8ZNVjQIg5lUO3/gvg9dMUneMbmFanRgJxDCAhsMc4DC2OPMnP5wOrTZa0UNh/pS6Zuz3WjMvHlB+RlB7jSNX/bUOt1vydS4OKItLsyhnmTrtMNsFb6zlYit6MqCrISSMUUdOwQxNAMxtKCXY5YQb7/+fTDEE6ZAFX5/xcnnPVEkvvSKeFMTPe/sOJQo4ZMpXFaDl9xOZ6283Uo1Yu5Hc5LwSjCS7RIQgQ3KSxHdLgtu2WaFkiiQBoyMPgRb5B3ceIkVnmCN40fqGbON3wAfBjVqbzkFWIMh9dJzs8cR8ulgb7nB75y7XjPwkJ7Ksg75D5PwkL5HCIwVxSpLTSvFfThtcDncNyArKc9WqD8by961ofHHlti9tBm5hI5CqUVlyc+eGWF/BZ/fF1Dg/A
 OBKljE5l
 geIFSAHwIcKpoSs9mgFV0vFUc+P0zm6QUH0EVmNUeoA4r7BsBZA7tZ5rS8q4O3a7diRGnu1leWrUsXaayA4MMFJqj3DPf+kJ08zX3875z6NBZV/9K55Xcs+Zr1YqSWfpVfcKNpfAlZTscBPyVBqb/5ZtlzqX1xsNOf7QfZiWbhj/b3QlP32GSYIaHCDFG67gPgHQlFIN/7fFOtBBIKEWl4VJoC+lzQgG9GU4Q1lN1W3LfQdL/Kb2Kgxg9tPTuGTHvWZf2CrRNWeI1KmgV6tfa8C23n5IbNlhdHFfecgxfat0RKcDGlZ/ynD9BMXzOqWtS3XKlaBc7bgBBcdPgxYFPTUouYrPbQmlT1JUzG8PSMovMLjMZ6t0zcZ31dXpkHgtKQtpjTatjIfw16105+KaK59OXPO45vt48vvpsKg2Vui4Azr1Xcb/zDHQwhox0q7inlY7sCiUtA1m9f7uf5AKls/skQqFANsZFmRSetdIxKxgqxILy7ouvAR7QqJfzu/Jgwn8jrXoQj4z/fVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4c..a8d49d9ca981c 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.53.0


