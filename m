Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BCB606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CAs83lxx
Received: by kanga.kvack.org (Postfix)
	id C13256B05C0; Wed, 18 Nov 2026 12:02:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA376B05C1; Wed, 18 Nov 2026 12:02:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9796B05C2; Wed, 18 Nov 2026 12:02:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E03F6B05C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:02:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1777680836
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:02:14 +0000 (UTC)
X-FDA: 85448857788.21.818B6FA
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	by imf29.hostedemail.com (Postfix) with ESMTP id 282D3120018
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:02:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CAs83lxx;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LnS2wCZZHURH1O6WKOvzj8Jt7ypHJB7p4O6pU8YzsY=;
	b=YoAiChdm+4ecy8+0Xl2PQeE8M1cGdOjYrS6UjxMtdrrM0p+fI+9ahUa+bKRCao65jpZY43
	IASHJHw+nbMLAnozb3AJePaG9onrORrYHXGVLWL6maxPN5wxpvB2LAa3b9DwHY83rbH7vT
	+cdQ6oBtq7w8HMxz/sClVxQ+eWD37pQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795021331;
	b=ef1E0sGowFWG1kqKxOj4f58GBbbjIdMX8HDMbsjwiF97cDqelYHuKwdOVHcdgDjfbO2kSP
	Z2TMdU+0RhyRo+Vs/KpnXGqOjzFZmOXA/Q/O4XwYYyVUlyGnIypTN/pAlIUFE79TJJTvQX
	TzqYy186oVa6VF5+jL1k0Z5X+0PuJhA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CAs83lxx;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m4Mz4Q+tATCDvMMXXL2FCPqcMxK6GvmGp8arGUL00SBNsQU/MyiEzzSCZDdSQ0ibSXSgFIzb6YJF04Q15GsPempNtNg+hXvHbd7p0YOGfvVbAnRHpZn/T/x6bM7eaxgDs6kt2sqWqp5MVW+dYkX42TYmFzGhemkxj/P+AcClG20OB5l7ZPBxwsxb5kN/5IOCWCSvYQpuh9FpmKVQHDevdxg8MepTjKI3FLG0gjSYnmDXVEEdNcgLeKEOGSsGyZkKXfVTzE3BamxrZrUKH50zSNkHcxjlSBP/gHSmQhmKEACw2VQiFMnMw7YVyNPNkNz7YD2/CDBOOSV5BR157cHWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LnS2wCZZHURH1O6WKOvzj8Jt7ypHJB7p4O6pU8YzsY=;
 b=WHqli8XbBbEJSEjC2q5p0eypcd9gKb8Y9e27dWmgao+Ra2UNYEoeX3PsAQ3RE+oSKks7VX1iV9Tv/Bu6GlTZRjD9q+f8bMDoETFLsOE59O+Pxnbp93eK63tSAk0FBJmPYY0nAwRxQkWA876gB4x2h+i5TEt1vW9FlGwcYXuu8URTPpKmnFFDqomqrAtYoetCQ874qtu7z+7TzX6GAmzMDuWEX6t9uedUh2g7VW2StvpRDbH3+evMiE9hYoKEJAxhyndbnV0Of8HUbqz6RUBh1Zzq2mBny82Lc65FjS3PJYYFX4RTQchL3Eqma4w0EWGjq10oU0B3/7N0sSih4UyPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LnS2wCZZHURH1O6WKOvzj8Jt7ypHJB7p4O6pU8YzsY=;
 b=CAs83lxx/4T8vWgn99pbYVHoPelbq4SGEsDBMh4pRpc7/VmYYYSK41x3IzrcAKnvxCagoo7qB69CpaucyvV4G8IH4udnoC3/VIL20kXPZIyba/FBAWQHx0vCvS8X6RLu0YrAV0L+tviJbyeksXAZGS9Us/tcC5abqBi5TCykaVwE6cf/Imy/0eZNrNIpy5EIhQrIhzaQaJx7grjL7lHC6qkkWcOWoVajq/+yC67PYJa/hgGqEP5bSi6nIFrpSYB+AieiuVbd3SvSIFZQZqkMitVy7LnF0ONuyUcql9A15X4h5sHKPcqnmVoEtqg2TI7mUk6W+Xz+J+oO+Lw4mgAINA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB999096.namprd12.prod.outlook.com (2603:10b6:408:353::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 17:02:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 17:02:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?utf-8?b?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Igor B <igor.b@beldev.am>,
 Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v22 0/6] rust: page: add page kinds
Date: Wed, 18 Nov 2026 12:02:01 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <37B6D4A8-288E-40E8-9214-EDABBFE49C39@nvidia.com>
In-Reply-To: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:610:11a::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB999096:EE_
X-MS-Office365-Filtering-Correlation-Id: 69ba2bcf-5d9c-4bd3-29ed-08df4595acce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|22082099003|18002099003|261022105027099003|261021121427099003|261026140227099003|261026121527099003|261102123227099003|261028144727099003|11063799006|5023799004|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	IZzlUV/5ke4F0dB7PLV0hxRKPi2xTZvsfSAO7QJj1nZDuSEwDRIHQ8we2N8ZyjsPpOrikfxX9FWNM3qD8pvLQ/Cmlh5rih6aLhZZlK1//VFkK+caCzQ77QVwVDvFdfTmU9PBftCILl3cufhW3N0RyhhYVtXvuq8qo8fnKodLIaHVb4Oyhy87w8TRBETpTjdOie/Ct3r3b3/38AHj3SD22zIXdipvzB9xX7nxaIEfVisOnVv7SMs8wPn0mn58tbZnMIeT/8sP2MvrHMRmrgdy1UR5vyknqs4fpfG/B0FxRT3f1/1dFLCsZFOHrqV0sLCTgad7ZD3gurvrmQFQzkiMz0F2OvK8nFhslYMOFYuu9s0uDSMncO3KLG7p3y8VQ3ATmYUY9UHHpLqYGLrnxP4Nl1NR9EEXkJkHhwH986lVJCPyMfPGy0Bjj5pe5Ks7cX9IlN7uDyHQ+m12mDxCHI3hu4uDYLGmEpqj/wfvEZK1WPAT5HDB2SDXAWLHJwJBFsk2+rz7jpQ+heNJJI2nN7sv6KpClzgyrBIeYrYI36W4LObAwN2ADI1jj1HQyaCzHEKdEeH7GAu5Szce6Xg5whUpG4sH/V5ui9OX3TfHKaeOirsd01eK8eVqnQG+eRWy+YsMMY2d8HUzJ+pq9/ZuMWv6kEmWu8vRRnOQTXcRzH5n7dQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(261022105027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261102123227099003)(261028144727099003)(11063799006)(5023799004)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUo2anB6aVBFRTNMcEJKSDlJQkFWeVVCSWxnanNEV2JMYXV4QjJXaGNsZTZx?=
 =?utf-8?B?TGFrR2FhbEFhKzU5M1JjMEZ3L2JsYjFpSWNqcVE2UXhBbjZhc0dGSjVVMEhH?=
 =?utf-8?B?dFQ5aDFmTzUxbXRFWEpORjAwZUs3WEM5Y2xibUxWY093VXVBWS81c2llTUxL?=
 =?utf-8?B?NWkzUU1rcGpRUFNxZEJnMitCV0p5eldISHNQSFdtanJUb2lTUWl4OUtnWVhY?=
 =?utf-8?B?R0tQK0NZTnZlN1dJRmRuTENmZlNHUWJDcGFLN1g0KzJPNHMvUi80M0YwSHFU?=
 =?utf-8?B?WjMzWE43VmpVMmdCcUU5TDlYYUp5U2gyVnI5UHdqVmI0RmNURUVYQ1g3dXZh?=
 =?utf-8?B?K2Y3MTZEZWI1RnVJN2ptVGNXejNsMklBVHhBVmUwOEZ4dkVpVDNMTm1PS01j?=
 =?utf-8?B?Rk5YM3I1QUNhenhoS01aTmFUbisyQVdCZy92dGZrdkhWRHRsZDdrcU05YWJS?=
 =?utf-8?B?eHljc1hhd0F1Qm9xU0F6WmJWOTZKN0hHTWVjQkk4cnI1Y0QyaTVlcDRZL1Ax?=
 =?utf-8?B?aG9kTDRsTXZtMGNib01nVjBhZnMxeER1TU9PbmJieWNIc0w4ZnJLUEs2R2pO?=
 =?utf-8?B?amp4dW9oQVp5cG43cDRWVzBMZTBRNnZlMnM2OSt5ZHNPSGxuT1dISzJJQkgv?=
 =?utf-8?B?MGhFcEcvNkF0S21hRU9QVWRJNDgvVVlOVzRSOThTNjZqaXp2Y1pyNXFFMFZ6?=
 =?utf-8?B?ak1IOGhCOXVOMm1neldrWUk3S2F0R0J6YWZWTGVtTEsyUXN6N3pucDREN0pF?=
 =?utf-8?B?MGJPYlhVekFvQ2kzS1F1QnplMFlaMWlnZlRRbmIyZC85ZE9jMVBZS0JuZHpT?=
 =?utf-8?B?eFo4bkc4Z282OVozdHBYOVFZU3B5OTI0TzJ1d0JvdGMrV0pkSHRZajY3dUdq?=
 =?utf-8?B?S0hoRGJUM3VpcFArWUZQalRiNnR3WG5BREFldGRvWkxZMjlkVWtZZFdZMThW?=
 =?utf-8?B?SXQ2ZjZUOE1SbGNPOHl5MklkVDlpTmdjc2hNWEpDWWlUWjJ0TUhnZ3lKV1d3?=
 =?utf-8?B?L2dwVnBrTzdRaHhBT1JTeVVJM2l0N3pmQXZydWROMFNGL0lzbmxtYXY4ZXZT?=
 =?utf-8?B?Y3UvQ0VUSVVSYi9IWTMyWXNBK1ZTdGhrdXVpWGZJYnVDN2QyNFJacG05b01j?=
 =?utf-8?B?SHkvUmRiRnZhNnFaait0cXZGVUJtQjBPbmJWcVN6WklLRWZRdngwbURNUUls?=
 =?utf-8?B?MVVINjVvVXRadUcvT2FMVDlidTh0MGN2NzhUNW1YeWtVbzBjUFpORDBkSnlV?=
 =?utf-8?B?RTk3VWFtc1l0WlpUbkV3a3oxakVKMGhIWk44NllXeWVHOFozM0lBOHFMUFZB?=
 =?utf-8?B?UEcwbEJDMW5OL0NENFZ0QnBlemZVeFR3Qmc3Q0xEMkdsMitQRmlhdUJOREZK?=
 =?utf-8?B?UFFueTRpZTd0eG01NFdSKytaUXl3UkNzeE9sTUdlbHcvZWJOVFpCK3JZak9L?=
 =?utf-8?B?d1JucXMyNkRCbSsxcHRNbWN2cHhWeWVJM0VDRDRBZ0FrYVlFUXMyL25CUjJK?=
 =?utf-8?B?aHg4YmZUZGhLNzN0R2YycWYvOW9TaHR5cTV0b1V3YWdhR0d5M0xPWi81U2k5?=
 =?utf-8?B?NUV5QmhNRlY5bmVnRmFYd1NRa0w0b1ZFTzdISnhhOFFUMEw2ekV5ODkyRGll?=
 =?utf-8?B?N2RWWHZvcmhKaWhRM2xCVWlzWE5COWY0U3NVYlp5ajhMbkpwUkJpeGFzWUpU?=
 =?utf-8?B?L08rTGhBSk5vd1AwRTA3bElWc1g4N2pWbWpGMDU4Smhjb2xGZlRsSTR0YlJX?=
 =?utf-8?B?QmNCY0pvUjkyQmRHNXdabHc3VHdUTVJicEpmZFVyajNtaDVHZVk1YzZYaFFo?=
 =?utf-8?B?L1ZEVWd0OW13RjZDMXdEOFVVbDBuUWZzbXkrQ0VRVDI5eXJJT04xTWc3Wkdz?=
 =?utf-8?B?bnlFM1NLWk1CUEwwaXZyOXZOU0ttbGhlRVJVQnYyTmxZcUJyRmR0NmM5cG8x?=
 =?utf-8?B?QWdqSVFpdW5TVlVCOXo2anduS1hQNVNiWmR1SWl1b1NyQ2x3TXlLazZFdTRa?=
 =?utf-8?B?MjVxWnErVjBkZmJKZW9YODVEWEt2dWZjb3ZWajNKckgwTHV6d09BTWlqTTB5?=
 =?utf-8?B?Zk1OWnpCc1dUWFNqN2hCb3VVc1VVZUVnVUQ4TExROWZoVTBoMlZaSGlyNGUy?=
 =?utf-8?B?dENXczdOUkp0dlhRcEhHRVhZYzdCL2hQdUVZYXBOZzRvTGdESTI4TllYZk9w?=
 =?utf-8?B?VW5iTk4vRkpNVERzbHlNSWNDSllGSmtWNDlyVFVXenYxelBUcU1abDQ0OUYy?=
 =?utf-8?B?cFo5Y1ltNVRpbkZoSnEzYUJsMHIxb2p2US95SEE2eDVpb0FuajJvT0JjZFBB?=
 =?utf-8?B?czNhWHhiWUNRRXdiWFRVODE0QnNJMzN6dVIwb1NIYnVvYTFxdXZXUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ba2bcf-5d9c-4bd3-29ed-08df4595acce
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 17:02:06.2943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3lgXYpESyVcTlfRg9x9B1QHSBbXGRHt5JIAWLIaMjDTQObY71TUI3hDCU+ccyYS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB999096
X-Stat-Signature: zshzi5uhkzjsibpe54whg6dxc6ph5c61
X-Rspam-User: 
X-Rspamd-Queue-Id: 282D3120018
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795021331-586620
X-HE-Meta: U2FsdGVkX18wSkVenAgaRb8LDj7mIqe8EJlcWUMPrZE5smBNSLzTqxXDqLj1LaSHzN7SpDjG6ODQl7J6BbyRbF/avwCQfuthamqsYTQabVdD9MiyLlnVwnwjW82QubW70UE7rrZbjXIZ1hC6XJppK3Remo+RXYqBeJJvZhjTsji7fwXnmrTz/qLMl6ltynJ0JGd1Q6pQJDj7LOTt+Wp46G5TJILbreJx/9O/dTFOudwupHP8DNjZuZOmCj9oHDHKBatPWVUWjS3OtS4rfoGvI18w6m3KisobU8zuPqv4rHbVjp2ZvVte4pX1gDLXwMViNjuQUlf2d6CrGRwLGlGTaA4QYip9TJqzMriN/4r3f90+bE0EswPx6uMOW70pakEz6sg6GZZAzKOxTkX3HBvmyKt5kWRvCq0hy34B6uQn+vmrqy8VI54Tdpp/8mOgLQsGyhs0C0X1F0Rsk/4mnn+/1MHTYkhRJtqp12na43a238Rn04rBdcgV2KhFSTrQVUgm0wzE22YkcPalp2owQxtLoMy4As8nzYciCGD7e97a8Qib9zVuUnCCnHw+ssS8jppYPkzH02SD5j0199OUW/Tkb9y7+cgDpM4+pq61f6ock2lDACdiuG1/69O0myyrTiddMehV5/1hYPb9vQXy4+sjEcEOlwUc/B0p4EAx6FzX7jmNNU7+gUl2+M+YTcP72xjwERJbXSzJJ4soMgWpZOCWFDKrJIlj+KA+9Vi2Am9bkhO3dG9CHE3SyUPweyox8L9NyuM5OlGaw6OOTlRWOcE8TdFxdhNIhavPe9dYH9dIm+jmfezC1Boi5zzN81PBDNI1O/Ff0/b9zxGtOVo6pydQllN1C/VrP5snrnB1g+wThhlZejWfMfnRuEHhCiYPI4LIyNA7/EgINbuTf3M1DT33QT0tgEgwCfcMUpJI3y+LaOoWqmMxFwRaYPsBQp7tY0eYl5iHVrKeaz1JRh3PAbH
 09Qy/Q+m
 4ceHruBgoNNcri6x5ZLGwVGYyiWHxekhQcIHAFabc736k2zGrsUv5VdkpybZ7gJligrgfKj6b0YBqo6P9xMKydISB9dCD/xNrfWx/GvZW7sESAyi05fblsEBLRPCh/vhdiQJxAnAW+qXHIZzOA9Y9rfSp6S/QwjOk5fQbguxd0fDjjnxS4XHCAFSyM+xjti7KYS1zZDTsS4FufDjXyOocJDL4KRQt8jM0UIDq1J95MNw3UjggCFk9bIIszeShkNpFFWvW5edaD+qSpEtX/GEj57PDTcX7dZXrS05DnXmpQQAJBaqjJc12rIyVAdZt/25wmT8lRr6e56U+Ab79zD+NFFA+KSRBZ2M+UF/iWMgF3RZ79LCeOkgKtCW6zC57TUUoS2z8KvKlXXU3BK+i0h319iOoX9rMHThyqdOrt6QxG9JTJ9Nu6Ypqk3m/2YHJUh85StyPoKNWJBD0Dvmpaka1yHadO46dT1mleoeA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 18 Nov 2026, at 11:18, Andreas Hindborg wrote:

> Note: The page patches were part of the `Ownable` series [1] until v21.
> This series continues the version numbering of that series, and it depends
> on v22 of that series for `Ownable`, `Owned` and the split of `RefCounted`
> and `AlwaysRefCounted`.
>
> Not all pages can be treated the same way. A page allocated with
> `alloc_pages()` is managed by the page reference count, and kernel C code
> routinely takes its own references to such a page. A page owned by the
> slab allocator must not have references taken to it, but it can still
> show up in places such as a bio vector. A frozen page has a reference
> count of zero and is exclusively owned by the party that allocated it.
>
> A single `Page` type cannot describe all of these. This series makes
> `Page` generic over a sealed `PageKind` that describes what is known about
> the page:
>
>  - `Page<Base>` is the base kind. Nothing is known about the page
>    beyond the validity of the `struct page`.
>  - `Page<RefCounted>` is the default kind. The page is managed by the
>    page reference count, and `Page<RefCounted>` implements
>    `AlwaysRefCounted`.
>  - `Page<Exclusive>` is a uniquely owned frozen page whose data area
>    follows standard Rust aliasing rules, so the data is available as
>    `&[u8]` and `&mut [u8]`. It is handled through
>    `Owned<Page<Exclusive>>` and is the first in-tree user of `Owned`.
>  - `Page<Frozen>` is a frozen page whose allocation is uniquely owned.
>    Unlike for `Page<Exclusive>`, nothing is known about who accesses the
>    data of the page, so the data is only available through the unsafe
>    raw accessors.

Why do we need to allocate Page<Frozen> when we can allocate Page<Exclusive>?
To me, Page<Frozen> is an observed page state from a non-owner point
of view.

In core-mm, a page is frozen, when its refcount == 0. The code looking
at the page knows the page is exclusively owned by others. If the code
allocates a frozen page, it will not check its refcount, because
the code knows it has the exclusive ownership of the page. To reflect
this, the code calling alloc_frozen_pages() should just get Page<Exclusive>
and if the code encounters a Page<Base> and finds it has no refcount,
it should convert it to Page<Frozen> or there should be a method
that accepts PFN and return Page<Frozen> if the page of the PFN has no
refcount, for PFN walkers.

“the data” mentioned in Page<Exclusive> and Page<Frozen> is struct page
data or the data in the physical frame pointed by Page<...>? If it
is the former, is it better to use metadata?

I am new to Rust, so feel free to correct me. Thanks. :)

>
> Operations that are valid for any page are available for all page kinds.
> All other page kinds dereference to `Page<Base>`. The purpose of the
> dereference is coercion: a reference to a page of any kind can be passed
> to code that takes a `&Page<Base>`.
>
> `Page<Exclusive>` is backed by a frozen page, as suggested by Matthew
> Wilcox in the review of v21. References cannot be taken to a frozen page,
> so the exclusive ownership is upheld by mm rather than only by the Rust
> type system.
>


Best Regards,
Yan, Zi

