Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B642606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CldxLP8q
Received: by kanga.kvack.org (Postfix)
	id 309586B05B4; Mon,  2 Nov 2026 22:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0F06B05B5; Mon,  2 Nov 2026 22:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1266B05B6; Mon,  2 Nov 2026 22:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA94A6B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:43:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D96171202C7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:43:48 +0000 (UTC)
X-FDA: 85392413736.24.7874BC1
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012036.outbound.protection.outlook.com [52.101.48.36])
	by imf08.hostedemail.com (Postfix) with ESMTP id 130DD160003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:43:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CldxLP8q;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793677426;
	b=VDtP5qXdP6Ek23IScEbBOSjxFB6lxG6ONq5AMrNls6G0tqHMwpa9dbNvMJz8mVrunqTIdO
	co5m+tnskh+wFE6mD99ZAus67OszSMkAOw7HgbqA5gEAeo+rL5c3+87z09ghajzpNb4W3/
	Lg41uG35sCVR+1WkbthYpXTPFQk1qt4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CldxLP8q;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgtN5yC078ECeUmauMp/FsABJ7Trzsf/ouIMDyUX8LE=;
	b=hqW9dtLhXhdpSQFioqN42wSkpdVMrVy0KiUgPjv8LdPEYX+VXnklTE6Ik0A43TMB/ATwsY
	hHdHbto88Wo9NhrU0lkSItH8F1mu0Wimnj86pvjVyTCiacnvyLZeAL5tI50kQDq9qZ5qgu
	ikMpgycbaGX0FTAt5YQi18zSvNP1+VY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tL2zpvnGk1n2Ab6QVbp8WUrHhLQ2as+CWiG7iGOa0KFv14boMB7RNuHRPUrjuW/WQV9l3Ak1Dz4lWfMJFruwtkBWOCvHctByFXo2DSg+an7Po9QEKiTzmmouHVls4ZvYi8ZwDOpmGYgjfMt1RlKx7qPHudU5rGDvZ/kgY2AnW8EcqmGMCQfV6YXuzuyziWy5LRUCZjlJQn6rMO3jXiCP8Nt6I4dME7E8y0htEE2kYiyy3/QEjgTl4VIsA9t1MkXHEZ3toPvOQzfCOSaqBnhQMaxy5oV+Oc0ZJ8Nj1plDkVE1P1kBiTo177oPqxQiZgTVC5twhcaHGUxWn6fC+rlGiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgtN5yC078ECeUmauMp/FsABJ7Trzsf/ouIMDyUX8LE=;
 b=J6vb4qiTjEeqSyoJVaQOLITEO/AFU6Tkd1kO62X7WMJ2SXGFDMEnUQq7dwjpI0JKEZzfy3JKZGUE08cBUN/8cAmnIDkld2XxsgRTbeWjae6X23X+OxZaXc1A0fg/Z0ANtC7pW1e2balbKTBspQMAcsvGg14uRAxZxBm7mBjhDGJQVb9DlTmbXmQSXFmuaW1W4I2MiVV7+YbR8YOOwy7msB/env6/bDQCDUYYXEaMmqkTAcmGxeAqXCqa2sEkn05M2zfsyl/unse4hYLfMkwQ279T+Dxn5afCK90GLHSaXQY2TBe6Ys7tLRmr2RPUVFk3osRHpSIGa706Aq8Y4HaqYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgtN5yC078ECeUmauMp/FsABJ7Trzsf/ouIMDyUX8LE=;
 b=CldxLP8q5jYN89wBWNJQ7kCeyNNwWQ0lBMTTL72OcHfj42YOsIELZNqb2QINRxY6DrKjp6Kq/vx/gHKaoQChJJPG4xzS32q/z2NAurAmhKVaJzbzTT9MPyXT2+ORBlzJBy52y3ze8OqHZEIOEK/wLp0SQJ7/4TGl3wpcRSkYm3gz/tN6Ma9uO+JezBcNxxTA0Wk8PbsW/ACyUjEn5ldvZbxcRtsah47aJYbHfvvd5utIVsGrGwPOI+WAYLOWp+rxWIFpGX6xh4usPysxjGdQx/ze7Dw55ZxpZ4XBdf/2EVbUY/TRYT7zKBZlEAmZVJmazct5yXrTPZsv0Fz8VMKf9w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:43:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:43:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:43:36 -0500
Message-Id: <DML9KTJOCA2R.2NBGRAYFPTTZH@nvidia.com>
Subject: Re: [PATCH 2/8] mm: remove end_page_writeback()
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
 <20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu>
X-ClientProxiedBy: YQZPR01CA0026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: b51b3640-4b0d-4e3d-765f-08df395ca551
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|261102123227099003|22082099003|921020|10067099003|4143699003|11063799006|261021121427099003|261021123027099003|261022075727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vYo/gq5xf1HBGvl6A5ijxeFpvLnZpzT2ZvL45gfHYQlJuVCFX41tdePNJqsJeqLLZEuVM/k8UiqAF7M/VlkveSljZwuslnsURj3IeHW4ulBMSZgJ6fmAKwjko+ToPF2TGuKuLug4q++5Dxt16MiaWrCVhpUIo8Gt0waYyV4KvX9dFjZHCVB3/w0AMkYVGs/C4yI9emtclGWxuxl8TprZWWhuP0rrFvocsyDY42rAZNz32/a3RtEqpmlrZTljyDOxZeRFX/cIaKHfZBujZSAp7gDHX3IiD4exqV3lim9V+Ol7qeY5b36DrsnrBVjGR8IG/e5HFyJY7zdN65dr3qrAfTufOG78QGLuk/XSJtwniOfiZLE1LmdEWJue+pWt5xfoDLckE1brNjVij6CZGyjBa/wfkmozG2Pe9hd3b3/OzT1nbC0SInBKsQBOvqIafg3loej+F3we9sC9H3IA/t6Se20nyQHUHGF7yTCcT1wIiNDp674mOYv218N/XVsizHB95far1y/tSdJ+OfwcVYjs2BW4f2g4IgzSnJTl+H1/3HPzwdfgiZazUHmgjb9B6ypf4OvqEduARLTLppP1rCibAmnlRGdoMBk4luSiyFijAm8zdiBF/r5VZa/OAu/0xCSuF2g8/GaOr9d7keJpd62PEzFcvDzFwUVNLRBdltpPtaxbxKGSGeFfiBJ2y22n9nzdJisHEF23K77gwE0WJwz9mg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(261102123227099003)(22082099003)(921020)(10067099003)(4143699003)(11063799006)(261021121427099003)(261021123027099003)(261022075727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmpQQlZCc25IZE8yNHZzQTFFVTF5WW1FRlhqMmhpREJmUWNuakZpbUlPaWJu?=
 =?utf-8?B?clEzQWlPeU50VDdMVEQyQU5CL2swanQ2M2hGWjhMM0JFQ0M0UnlSZ1VhR01p?=
 =?utf-8?B?c3crbk9WejMyeDVmV0xzOXlFWGtOUkdob1R0QVJpWUliSWNENmtqSGNxeGxt?=
 =?utf-8?B?YUh5Ymc5TEpuSFp4UmlxNzJmTVZxdi9INkFDeXdvNGFIQ0VOOStPQXowM3dG?=
 =?utf-8?B?ZmNncGNOOXF4dklxZndmTW8rMjNadytSNmpoazBobU5SbUI4Skx5ZlRIUTQ3?=
 =?utf-8?B?dFhqaUgvZVFUb2FWUHFCT1YrVVBDU2wzVUZXNHc1Y09TZTNJRmx6bTBUUktx?=
 =?utf-8?B?LzZNWVByR1RBNTYwQXpSYW9hMTRId1p6WHpZa25iNW1NelRFcVJoU2pZTGp1?=
 =?utf-8?B?Wm80cE1iYkhqVWEzelZNMlJxOHUrUG9mYjNvTE04eWE4NzIrQW0zU09SQzAx?=
 =?utf-8?B?Y3M3NGdwWlhRUWxLVWEyeDVSelduM0NPOGc4ciszaENhUTNCSHpVZFYzMzR6?=
 =?utf-8?B?VVcxYmc3K2JHS21yOTVSR0dGdm81Y21paGhuWllsRGZNK3RmQ05pUG1mdVRF?=
 =?utf-8?B?VElucUpEWmFuSm4xc3dnVkUyZmFLRzUrblhtaHBpczlTYWVkZjFFUkQxNEcx?=
 =?utf-8?B?cEEzZWgrYWxGa3FQMGhCUDd6YzdKeGtDbjU3aVZQZHhLTWRwUkFBSWlHYWhy?=
 =?utf-8?B?WE9vYkp4TmJObUM2blR3cDFMK2hhNDdnSzlSY1JlSHIwQ2I4TWIveHZHTUN1?=
 =?utf-8?B?b2xrZWtFb3BXeTNEUEZmS2hYUFBDZ1Rqa1FkaDJxWmZwWi9WUXlKYkxIZ3VQ?=
 =?utf-8?B?MnpFTGVUUVRtMFZQWXUrT2hEbXJNZEV2c014OVlEdUlBT1JZQW8yWXpFaFRw?=
 =?utf-8?B?VitWQk9ERXVPbjdUdCtkRDEzZEpLRnlUZTR5elVLSjZwZWVvQnVDY25FTTRj?=
 =?utf-8?B?WjJ5bE9SclZwRzNnOHYyZlprM0lZQVFXTnk0VTYrcVBTckZPbkF6ZHh5VXhO?=
 =?utf-8?B?N0s0Wk5qRVRYYTdoMWo5M0FmVW82VktEWE1aSHlZaWpMQzBLSmlpbnF3SUtR?=
 =?utf-8?B?T3ZteFo0NHZNa1ZmWEdTUUpMaEY0OE9TSGdjbTZGYkxITTBHOGUrZUFhN0sy?=
 =?utf-8?B?eml5SllsRG5zckEyWElmQ3hKa1liSElUczJ6czZhZER5L1crVHNRTHMweTRt?=
 =?utf-8?B?bmRTNFlISk1XeUx2WGQ3SDQ3eWlVUGo1ZFVmOUI4RlpIZkVhOXNuY25aWVEz?=
 =?utf-8?B?SUUxSG1adUJVdG9oWHRRSWFadkNibnJoeTJwdVhvS1cwSXpaMW8vTTM2Z0lx?=
 =?utf-8?B?aVNZQmR6MUVBRUlTcEJ3VnYvSjJQd2ZNQ2lZMkpyZ2NuaE9VcVRWTkVzL1Vv?=
 =?utf-8?B?R2RpbHR2N3hVY0FubHdoNzJYTStMRWdnQU9DT3gxdzl3R0RHd2VaVEdaY1Vk?=
 =?utf-8?B?YkZ3WC9oWUtJSU9RQnduWFd3RW4veUNUSlFsc0JsbEpyRzZRS2t6R0lhOUpn?=
 =?utf-8?B?QWNvRVV1a3A4Qm9SZnFqQlR5Nmc5cXdOekpVVGJMKzBBYTlwOFE2elFGY0k5?=
 =?utf-8?B?ZE1pdElYdFBxdzQvYzRQU1FUWjB2aGUxc0J1aGROam95dW1HMU9xcWV1TGsr?=
 =?utf-8?B?bzEvVGdiT1VYOHhHc0NYUVlBYVV3UHBwVHN0RXlxek9OMk1iUzZ5UWp5dytZ?=
 =?utf-8?B?c0VyNzc0Tjgwdnl1UVNBT29LaGRqNmF1ZER2L3AwZUJpTXRuNDZXRVJSUXlo?=
 =?utf-8?B?TGlURzdzU1lEMmRRalZZelVieE03R0JjcjliRHlGVXZEZ3VxTEpVVW1aQkdq?=
 =?utf-8?B?VEF6WmFNUTFzdmhvc0w2bUhhM1EvakJvSGdIZHZxMy9yOWVoRFROcExpYnFu?=
 =?utf-8?B?cU04dStOc0hLMnN1UnQ1Z1FBaWdGRzJHVEFpZHpOTW0zSnhBSmplQmk3TjBh?=
 =?utf-8?B?YVRZdEdPb3dtY2hHVTFZQWpZeWFuemhYQWV4aW5RRXN3RWpsL29mYmJma2JZ?=
 =?utf-8?B?VDFzWVRSRjRZZVdhc1VERHVhTTFWR2RMblc1UVBuMW5FVHRCTGhSelplM0JS?=
 =?utf-8?B?dE1LaU9mQ2FIdzZjTTNMVDBmK1J1NU55Q1JsZXY1bE8vRmdnRGppdGkwVEl0?=
 =?utf-8?B?d3RaNVJ0Q0xXckk4K1ArM3o1eno5ak1yQmo2Nmc5YnhSVk5sZEsvd3dxck5J?=
 =?utf-8?B?WVVFVHZRQm11WmhOOHJ5SE5EM20xT0QzNlN2U2phVnNUaGxnMEtuaFJwaXM2?=
 =?utf-8?B?N2lEUGdqaWl6cGNJVmxicElQZWJyUXdrTWZlNVBEUlVYK0owYTBjM29sRDlo?=
 =?utf-8?Q?7Cu08BOJvPqv5++Xs+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b51b3640-4b0d-4e3d-765f-08df395ca551
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:43:38.4299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WTXj1eyo/2x6pL3vWnQhs/SOtWHDWoIymxhMx7CUvD7LOg3q706QjA7WdSOCogj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 130DD160003
X-Stat-Signature: 9bd8opar9tskey8erx4jcagcyxkuy9ta
X-Rspam-User: 
X-HE-Tag: 1793677425-319373
X-HE-Meta: U2FsdGVkX1/d+taWA5U+4Zp9Rasb4xf+vAK581bfrefWZEdbe6VhaKd+0n0Z2l6iJynUrt2yx/7/aCDniOEGB9PjEqT38EqDtHKOyRVVN52eFqWnXqhpdVT0trsWTlBm0wzuS92tz53iSdX7npJ97u/a/C5/ZUIWDYvhG/j3snio8APZMLSICkPgq+GNFd9Y0XVn0paqjg47eJnzNnRqm10EqtYc+vo1M7iF4shGwL4lPLnHS5gJO2g+8dx9znABiPQojZ57qDdth17Tx6U+7/h0yRtQMmTWFFNefLur0B9cc382IasUn5Tf79YzdJv4OypUkqjn/BkW9e+iYz2kyM9W2IaVU1ZXjW0zoq3u8TIfNbRfOI8T6DXBOrrVKdt+BY9CRP5XrqeNpnTOXhaqtEoMgHmJ70gxMkRUV3W6zByv302tZUCT03h2p2iSTzyQcIs9/nm8IoLQ1BD92QWWwJ/dKiuU01e+JsoEIWyHczrxZd7hVbjGCu42xqGkXYSS0NVnDHgtIfvyMxu3nL5oMORtjl9GQTd0UDPW33Mhl7b6Vof4L4wOf2uZloSYtL/zaeusNWianlPnYd2sqFBZ1WD6qA2N7ReW8v4PUCcfSGQi1P67IA77+mX5P82KLOv5EzpDdeou0s55j3z5AcfTkEzXZY6ULZUGm2zvICk8olq2d+MC2npdz9N/ksWaBRoGJt3mYqvwVUPveaPrMuirIl2E1CzOVJUtVs4tuJWpzudzskpt86glUOcmKAkNLIR/nl7Shl+l71WGElbHGgeUv/ia2GTbn/G+SzFZd8dL5qXrsfGsTDlrFTQnsp4xh4gj/24ukCDYc25L327sgwgCrqKkOEbYhnWncB2A7pYr+49q+c4rDRj+gFaVwhNUaRr/mGVlXTRiNK3gVFdDtf8aJ2yXCJS3k6pARBDYpuCH8yxy6vQrz5FBOOEA+LV70QhNhlpZgr/PdbQo8SbpXYH
 XICKoWfv
 TjjCmXlYWA28P4Qu8Ot23gd7q+ckPshKiL66FioEQGkQtH9QIEWxVHlFNlLykmYm7mZ3t8eP7/KwBcilDz6yILZw5UTuXWApfOhkGy60QyJ+GzX2zFrt0yjiWhQm8EYS7Dew2Ewnb5Lg45SBegklvz7lXcN6PQf9QCjw5uc4cLe0D2sh14ZOQPacqGu5JtnubnrqID/WSbmIXnj92fSGhYUDBv4tmMG+mtylJoGfLBmu7+7Igpq1Lv0d7fmGZ/a9LKhIf2EBPlNGVG2eayv7AqWdBoox7amA2dCK8Oh1R3N1+R2TthZ3YosSbUsMNHCTZCprQe/wc/GOtSUb/K+eY1FkZpv3IJyVG2K0sBQPKfuXZZwh8LjGYlObPf3mxr7HrC35uPqK6u6QVh/gcrv1DA0RyODn/AvBi5XNtSgUuFjNC5/du2EMcut8GfC7u4T5aVJNh444B9WNk9aujqxsNweUxie2hh3yZH7z3zcgC3th1Q8iEMSyyrOdEV5cHDYp7F55v1TWO9cP/mSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:54 PM EST, Tal Zussman wrote:
> There are no callers left. Update the two comments that still named
> it to refer to folio_end_writeback().
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/pagemap.h   | 1 -
>  include/linux/writeback.h | 2 +-
>  mm/folio-compat.c         | 6 ------
>  mm/migrate.c              | 2 +-
>  4 files changed, 2 insertions(+), 9 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


