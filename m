Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE48606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TC4yCZsW
Received: by kanga.kvack.org (Postfix)
	id 50A256B05BA; Mon,  2 Nov 2026 22:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E32C6B05BB; Mon,  2 Nov 2026 22:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3A76B05BC; Mon,  2 Nov 2026 22:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 129FF6B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:46:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93A95C028E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:46:10 +0000 (UTC)
X-FDA: 85392419700.26.687B145
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3494140003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:46:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TC4yCZsW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eq+0RKs9TRA0PZKy8ir59viWzstZo7XmtITAeoqG1wg=;
	b=eT/VkPxeR98vcIUg7wPp619Q9zMmDnnZZ9F9GSTzV52TeNT5OkROZ+A+lEq1BnKLx1k3vp
	POq4o9iWgsU1BbBk8mGY/nvgg0ChDY9I3Q7IkfGnZDRd7kjnslOfGpHugD/lprMyb+Jwn0
	fdB7w5ZLhG9EtqHitNgOtAsjsxNQ0n0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793677567;
	b=0rN1Beby1j6x26xGA+sQvXqRZxrkkI2DFnzDTbvpKWGxQL2IfV8FK1WcKlaqRolOgIodo6
	UPqKkiH2xlLmwQg3j0LRxDaC6f6lN2BZzacZkXLqUyH5VBssCWVAiYr5UCsVVqu76Tkr44
	UnsjurRE7Uk8g2au29wXulfH6xizAtM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TC4yCZsW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOli3Q6yQBxH1UpBTgCOBDbvdkas8MGfXE7zgHdxWZ0gGjDfMm2+7YxzU7qEBQfUAtsOd9oXGwvBR8QaldtztJzM4RRuHRdQ/viU+1tB0l3YaK/NSNsZksF6DREUkxtnhX4K7Rqqpt0Fa0y/fD6wg38gwa1LFuNMi3H4VwxwelZls3x8Xwxt2P7q18eizG7jG/0jVoK58M+9ZGK+qEdfTbx8O9xj34CRZhAZND9Xzuk2XpPoioFeU0pYRWBRoOty/vjNnUZM67IZpLF9l+KO2CUS6avaY/5hLyC4/ZAw2ZI0cXW0i2Ai4mecKM1Pn5mWI7HHsAxtLCE9NqOXvsN9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eq+0RKs9TRA0PZKy8ir59viWzstZo7XmtITAeoqG1wg=;
 b=nVPD5TJJxvDDssAUvKXd9U4o/lUJGvAy5aC9JCWPFakgLzGUo0WH+kM3NBwxEzlXiGxFotVHcTL30eN7l3jCkDAOoqBOGpSkACxFEBg6Ki4VWzlQ8X1W/bW1AmChezlWmXIJ6gvYVWLshGXwbrlSDbHyH/FijNR1O1svvO+lG/RL44KcgZpFa3Y9LB5TdAN9zX4nap5WxtJRQ25y0ibyDCPHWBsXQ/cFRJd+URtuC9GWilGT4CS+eu8FIfhmJLc8N36jWdNm8Y6AUM8TycK6e/NdP+mzbmNHMEB8q/Duswu91KLaUh2q76kRuNxgjP54kFnBmEgcQ0TMCIyYf8VQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eq+0RKs9TRA0PZKy8ir59viWzstZo7XmtITAeoqG1wg=;
 b=TC4yCZsW0NGfJal3r6oMazw3vysi0StAbyjifgshkATggeq+Z6I/qCLKwdaNQjCJdNm4fGzoYJbY7JKlfetrCZDfewR+RVHW4lRS5bzVGiNZ24URFZ84Alj8f6y4FamKfoY70N8YtW7REiXDc/QP6zcy/DtSEjFNHnNkxa1zZVMaNZW9HzKEYfzk8hhFME4J40kpQXL/Vevv6DbhUC+E1pCZMg8ov5zw+4pMP66ugc8I6liIVw9OGWKn9d2Qzb7vODH9eR7/AO3/xV+stF8evsXU5p9UDWo4S8rc7d6pBv5Q43zaxJ81O2Psz/DVUJzCanUkqiVKPHrVn1pvWTBpQQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:46:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:46:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:46:00 -0500
Message-Id: <DML9MNSRX2O8.2WLE8SRPQMQNZ@nvidia.com>
Subject: Re: [PATCH 6/8] mm: remove find_lock_page()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu>
X-ClientProxiedBy: YQBP288CA0040.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: f29a7dc5-86f5-4574-a74e-08df395cfb33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|261102123227099003|22082099003|921020|3023799007|10067099003|4143699003|11063799006|261021121427099003|261021123027099003|261022075727099003|261026121527099003|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	DOSqRHnO1gOtHX59cwxrHz1y6xawGum6ib3j1vxGKvAuud1H/JApvzC6IFzoc5L6uZKQiooeH0nrL5ulxyMeWG7mBLaHoJ+vLSzagMWdn7By8CNkSCgItwXomSjq+5HUOTRac1PmLdYjZ/+pD6HHmv83uI+oZmgvhMPeAiOhs7cxf+DB7JD61FizI2qaxzyWblZdcT4F+Lo2vv9aIZ/cqqL2AMc8QoJgPdGYBq3Mbuchr7fXYGCY/HCfOcO1LXtoOvyFlDsKKWjIw3s5Kox19ZBiLFXBKpDy0POzEBBtbpN6EXJjnuHQuKcsUgqgsK6HphCQtpomYRdReREcMAv6fyAsvgptLWfdqaWMoJnrBvV3AU2ZCQwvYdcNqHjtfDVDPYkLi341hPWGNe/S6HsXGBlQhlm+a5xUPn6qRy8pFzm0yk9KNJGDRb23vxPqJSnIymWaQFM/944pI2V5n/WfJQV+x34jcx6XsZabtou07BhbP37gvhsrO/FcgsGZxoH+XkmfG+FkK+J//22uT+TTTbDIB6Hu0GzZ+ieMoQJ3plpzfGURgtnZd41zXAIbpy4HMhH3450dpBYLqyJ6EQg6YcVpMbX3+EK5jd619nSzw+4oskw23hXaF5o+4JAXCEGhKqpEj857KikQ9y2D0fJlK4oHCt204w99fgCLEPaWzxMwgcHcr4K3l8u7CX7khwXz50RDI2vulAZO/ixndwcQLA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(261102123227099003)(22082099003)(921020)(3023799007)(10067099003)(4143699003)(11063799006)(261021121427099003)(261021123027099003)(261022075727099003)(261026121527099003)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHVKa3FReGtpUXJabGJsMVpQTkMvYmtUZm1rM3BKd1J6REVSZHlVTGR0eXF5?=
 =?utf-8?B?Q3NWaVdGWkNkTnVveE5tNEtMNno1Q1lCNUl3TmthUHpJMlVRU0FtdGExalJy?=
 =?utf-8?B?S2IvY1dIZjNacG5QeGdWeGlFOFBVTGk5b21EalRMWUJCM205d0FteWQvMHZt?=
 =?utf-8?B?MFlvSVJjdWFCQm9zZmhlTW4wOVo2K0RXNzdqcHkxL29oZ25OV2ZoWUJZRWZT?=
 =?utf-8?B?aStuZ1NLS3JQRmZ1Y05GRFlMc2RNRVpsRzV6eGFBQTY5MUE0c0V0Kzl6YXJK?=
 =?utf-8?B?bEF3Skd4dTdKY05YMkZ0ZmVMenc1eVZudFhUS2JWa0F2bWI2TFo4OXNBM1N1?=
 =?utf-8?B?UTNsNHlzVndlcjlHSWtidTVOUi9pZFptYzBEdDZVKzJzd3J3Y2pFYzJoYlhY?=
 =?utf-8?B?WjdwY1VieWh0SkxBRWc0NHJMTjAvTGlSbG9QR3AyaVpOS05udXZYQUhDei9H?=
 =?utf-8?B?UnJBZE9ER3M0U3BHUVZMeUNydHo3S2RiSlZXbXhPS1hMTEhQeU56cEJOOUlL?=
 =?utf-8?B?eUtkUlREM0xOR3MweEJQdFNDVWphSzVqd2E0eWFEdXljUEYyWExTZGhrc3Nk?=
 =?utf-8?B?Q2hvOUNBK1J6UkM2VzA2V0lFc2thakU3R1ZRcEFPQnl4U0ljM1FnVkw1WjYv?=
 =?utf-8?B?WUc5MWJTSjN6UnB1bVdmK1hpeS9zVmNjbkFKby8xN09WeGJMVndreXNnMGZ5?=
 =?utf-8?B?NThDUUx3NHBFSm5LTFROQ0NUWjlRaGRXQjhYOFBxQm5sZEFzWWFySU5Bd0Qx?=
 =?utf-8?B?Q0oyaGlnZ2NwRWRsOG5DNkJ0NmRWeE9sNEhiNlNlU2FFVnhNZThnaWJkR2Yz?=
 =?utf-8?B?NHkwditSSG15ZE9HODBDYnlCb2VOM1hLdVVucGErRXVNNGpveVlxWnJ1SEtE?=
 =?utf-8?B?ZGRHdGVBQUpPelhGOGZRUHVTOW9ZWTNGclVRUFNzbDhRMUpHSGZpTFp1OWYv?=
 =?utf-8?B?dXFMY3ltMk9JejUwUTcrK0Nza095a1cxTVBSZkJmRWljWEszaFUxY1VWbEFv?=
 =?utf-8?B?S0xkenVRdWRDY2tKSHRhZjJpMXBGK2ZyR2lYSlJmYTBBRXlLZm1iYUNkZ0tN?=
 =?utf-8?B?eExWOG9IK1N5MjNtTnZhRWFQYzExSGtTWDB1bEJvNVNoSU5BeWxRcThxSmdj?=
 =?utf-8?B?YTVvWFZURVIydWozR0xjT3A0a2FvMHhqdGRLZDdBOUh3YmVwSERESjRVSWVs?=
 =?utf-8?B?SVEyT1JobjFuZHJPQkFiTStIRk9INjVwWmUvT3pXLzIyZE9ZWEJLYmNmQ1BQ?=
 =?utf-8?B?WExhbENnQzRtV29XZmdLTXhMdG45bXZ1L2lWZ2JaNVdZN09BVm5KWGFpNkhO?=
 =?utf-8?B?VWgxbWNtMkd3S3BsOG5ZeVdsVFlTd3BYenFBajJrRW5UTy8vZitLS1JCbzV2?=
 =?utf-8?B?RlhRVWMwWi9rVTFkdWRBeXY5Y2xSNmJVWHpxaG55d2owdEh3aFlSY3FCbXJJ?=
 =?utf-8?B?YWlheVBSYjVKSmJDaS8wTnF2b3h1aFZrdlVPRUJRdVJobFc2bW9nWDM2U3hB?=
 =?utf-8?B?bDg0SGNZVzh3cUZvczdvSFNKaC84MnZIaFEwWWdKUEUxYXJyMHVhN25kT2hE?=
 =?utf-8?B?ZkxpUzNYOW1IRzRvU2s1WWRZWjY0TzhkNTVkRkNLYjdhRkdwSmxLdzNudFRO?=
 =?utf-8?B?Y3RnQ2tuM2dodnI2WlhvTDhhbk41UXdFSDc0ZE9LQ2FvS3VFTTlzdXkvUS9P?=
 =?utf-8?B?bEVzSmxITlMvdFFKN2dNK3BSUlVqWnpjL2xSamtaWlBER1owQkpqNks4Njcz?=
 =?utf-8?B?eHR0cDgxbDZ2UTBvajB0cGJoTGxVU2xTanF3blpaeXVVUDNZZERkWHBZS2lH?=
 =?utf-8?B?RDdMQXZ1WHFHVXdnalRFaXN0M0k4NlZOWTV2SkFMVm1WM2hpcWR3ejBJcXI3?=
 =?utf-8?B?eGg2MjhMTWgrNE9MR0VTN2JERUxDYzd2YUpNMDcyQ3o2VnRRSFRkN25mdjhP?=
 =?utf-8?B?NndBcTBXc2oxV29Kck1oV1ltenF2bmVzWU80VVY5VFFOTmtqNGhWdlUzOG1W?=
 =?utf-8?B?akx1Zk4rRmMrS1F5eEJVeEdwSG1ya1NMejNUUUIwMkZLWDdyVzEzZm1DRXZD?=
 =?utf-8?B?NjBKSTRTZGpuaThvY294NFhqSm1vaG9lOXJTcXV6VitteTZyNEdYdVdPcWRB?=
 =?utf-8?B?Z1lvWjNTQlVUa084dVlJNkxNR2ZPUUUrVnJpMW5PQTBpQXllMzBJb2ZOM3hD?=
 =?utf-8?B?Nk1ILzBUR1gyRkdIWS9xOHViSWJoMndSRytRVm5LZDgyMWdaV1VHRVNyMGUz?=
 =?utf-8?B?dmp4N1ZSZkZma0VCYThaN3g2MFA5TE5rWGJvZFVpMnJQQThNTjNZajVUUHdN?=
 =?utf-8?Q?5v+27mY0jP2M1huewG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29a7dc5-86f5-4574-a74e-08df395cfb33
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:46:02.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBuKAz8WTck2NhLpodW4vGeTde/Wx1ZO4hKjC15e8KG7TCzv+mjm60hy59c98clC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Stat-Signature: gagzbgp7kxmh9frnbmkidnhkmewobodm
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3494140003
X-HE-Tag: 1793677567-698918
X-HE-Meta: U2FsdGVkX190KbhCpJARDdb/+pwlAYDGHlh9076N9de2f/Qkib8L4L9T/b14yPz4xHwshioILep3dWtKzdHT8N+luJw+6M8iOQj8bekBuQABY6PQXJD15+/JOswBKvAWRjlsJSofBOAc5cPa2n8MMn3vZLTTP1MV8Mu1iVvTCtqj4DlGeaMRF9h4CeQQC0hvxvSxkDTzmzpTdHhzHgX58xi/C9SBz6w5oAHiOTozUP1y2sg331kQnRIuSPnMgSmksQIJeKoisd6+692/kaa/WCvfwBeh2dnX4It7I34TCnByaZlc4JK9vDcxxPRXnacq56EOFB1VSV4lATdMPHksGq/q6+d1Ug/Fcx/tP9LDVbNPrTq9gyPjrzlinP0XEAfEmqJ0Tk8mj4RlwvnZFyZ2/002zOn45CLqgucbppAodomcNadoqZapS7TUJQJY7RXWk7unn4Dv9MfNJIfApa9Y6CX+rkeThyNYTRw7xV2nN6fPYr61CLZlOgHv/7fYi/21C7LD+exy5wVomTbFSkKL3cHBXnseL5iak4x9ypxXnibcd/XO6cAVfYMJRzAqHYcmSL8cZMyZEogxMEg3BRxzAm3H9pL4C1IXMCP2dTofo4deL+8bGwvcXyd1vEbPN+pLuVKvuh0Ck2sp54XJ/DiaYqS1D6JSwp0WMmjteYBXxpErll4gAhJ4thS7x1PUm967WJGqIjoPIx1nABkkCx+g1nq/C0BS8H8fCkuOe79fLR1FYqZktczL8yQ0VjR6Leg+Vik78HzWKDuCvbF42gu7aeVYWXJvUs6ypizTjJupxcbx9OEnKhNQiik4BmTviToqgrgCA1dT5Hvc+zq1L7GV8LsFiUHuUoucspL5R4JPoQGgja/1eP6fSt9huLALnPlw6JLhDusFNyGYtoqBToaSulQCc1B4+iT12jCuVH7Rfzoknt5Gbbs2+uUd6+QleXnsL7cEIMYFXHluz/s74lh
 WYpe/ZeY
 uN6437VSRW2eRFhDtSJT+4BL4VUu2NJpt+k9x8xIeowZSCY/mPOzsBmwb0bmbQaPudFg+GiloTVir/e3AEOZdSfU2B79bleyA5f1jqSIODFFyzxKCFTDWVGYUdJzDmLNZg0kkVRjaVvNeX3pkt0cPB7YGhJWt9Oj246Ae7QwccMt2kAkg24FTqGrnn8aR1cV7ps438rSU+Vq9jR8RE9vK5h2k3sTUmcY7AOAlXMQEMXHPd1tpnsdMzMiH4IyG2SSmMll/J4RX0dcbo+8FVnBajbvKxIHQRDENXefqDeTGo9Mt6FmlHcI462+cf4uBuIkkB3VXXE6QtlTDxD6EHoOWvJKYuRaQTKUu0ZaorJw5/qjwwd3zVD4kCcrKvV/fM57dxsNrcey6DBXs2QF7unuSAxBnGa2qrX7wGJWqz9H4WYeV+88xaMSQLd29ht+ot02y7rrcUdCO1SJhOaAWx+UE8nOe/Se6DMFH5LJbs3LPh3Zu4piEmRE1wWlJIarOgEs5NhQ6vQnSeoBeARU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:54 PM EST, Tal Zussman wrote:
> There are no callers left. Remove it. The name still appears in a
> sample function graph trace in Documentation/trace/ftrace.rst, which
> is recorded output and is left as it is.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/pagemap.h | 19 -------------------
>  1 file changed, 19 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


