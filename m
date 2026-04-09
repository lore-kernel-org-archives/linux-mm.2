Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299C1F364AB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612666B0089; Thu,  9 Apr 2026 14:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2B06B008A; Thu,  9 Apr 2026 14:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1456B008C; Thu,  9 Apr 2026 14:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0956B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:12:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2D8614016B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:12:53 +0000 (UTC)
X-FDA: 84639813426.08.479FC72
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 179A41C0011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:12:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ENpR04yw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.46.54 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775758371; a=rsa-sha256;
	cv=pass;
	b=he1SWZ+TF6qsPy66DkqJsGDLfTLr0I6b4I8H2UOfafaPvADTsq3XmgBnJ7qLiUKWqUPDgR
	VVtAh6g1Wp5wznhi4fJb5TV0W/UbY02DLteM4qADTYFXSY4JObuGDyDRgs69TsYfNK7Ax0
	RLSyfs0zeYj7cV8w5UMomESRMoUcICc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ENpR04yw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.46.54 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9ph/9YsK14cs4xv8WAfLq/uUtv800fCtGSAvH5k5bU=;
	b=XOsOj7CdisB21C29pp308aMoXYHYa/Dp3sm3p2nALx04/WB0h7K472+Y8jUnjRuqFNS2iS
	OxYBShYDYUKBT2WoPWuTxA8ejKejiT70uLxc4QokQIgApqzc6lBrc9Yl7BsFs4OWjUCG3F
	rQOMOPa9X+j2khUYOvHFCkeYswubXIo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wPv/3VFcgoNT8YSDh1s0wBAHcbrRSkg6v2bEp3Xq+tbHEo4EdHDMeHapHDlxpuYDIST5FQYw5MLknLyOolB1CUxIIhJNglRWZcBwpOHTfZlcrjiNZJms8VDU21LjThmhWoZiTL61rHSdYwoRfyOHrBi8psvwsbE3PMY++w8HIeMTCDojBPGL9oX58UcTcA973PTWyjCEI6qnBPnCRE8yHDoqhFFFZhw7CYeZ6WmhIDiqC79FlRvDGD4x5U81sPwuT20g2Eo48gBknKvCYUERhrdaqLy7XJwVqHbkAm8GSdjCl21M2BtnKKW/6UvaKtJNL2CnW21ygU11Dy8k8/KWbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9ph/9YsK14cs4xv8WAfLq/uUtv800fCtGSAvH5k5bU=;
 b=HP1xJh0IkgHH0qtG+ED1dtkRCDnDgXKD281zTNnBiKHPrx++iLICLQg0TimE7FMff2Iz5aIMVrdT3wnBz/oi7AKHDI/Li2hPRHf7eFq+NBhXr4Ijq5TbwJmL4RCZZnGp49UD2Forq8haNhUP1HZsdbfEZpLuq8gkdMMEFBTtdTIosMU4JLYL1I5hhkZWU8eO1P5cLaZmt9pj5gyNy9pVq9BUjCqPJ9hne7rqwEjA5FFi4lo+A0JTZQIBc4ITlVKtIX/pJF15cYGYYCKOIG7t+VrAAbfxxj/7dL6w+CQeZVru+psx45X7vvwaM9qztUrwKjFRLQVZ5X/lDx0vLVe/1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9ph/9YsK14cs4xv8WAfLq/uUtv800fCtGSAvH5k5bU=;
 b=ENpR04ywkStmLID4S2JTxbsQhfBmZP/bBDLnJP2YZN1u3RpMy3L9BdaQvHz5zyeP+wZYo/lxUXKINAcmHA9ARwigXEEreaOdbGNb6sv3OJlEOMHWWLZEfQE2l3OgxRn2xKre0g4xdWb0Dc1QUqaOYLACLSpN3HNoB9CiWyo2fNDkwUJSKr2b87Ixmeq0gBoA8kB9e0uY5XBDpHLkwApfjB+lH/qyWN3EHnGRoHvv+ZmvWkHSITMji6cJGgl0sZTpKaOzMlBv4X0v2elEetlZtKnDumOBTSaOsTmlQ/yNeo3CVoaNntX4Qmpc4xcbe0tEAc46B8yQIf06TReCVbuu/g==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SN7PR12MB6767.namprd12.prod.outlook.com (2603:10b6:806:269::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.18; Thu, 9 Apr 2026 18:12:41 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Thu, 9 Apr 2026
 18:12:41 +0000
Message-ID: <2cec5f0a-93cc-4572-9793-17f9fd123d2c@nvidia.com>
Date: Thu, 9 Apr 2026 11:12:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: Lorenzo Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@google.com>
Cc: Joseph Salisbury <joseph.salisbury@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 LKML <linux-kernel@vger.kernel.org>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
 <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com> <adfhGOHcg4AF3IFn@lucifer>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <adfhGOHcg4AF3IFn@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:254::9) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SN7PR12MB6767:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b93637-21d1-4b24-61e5-08de966396b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	V/j0uziNur301J73rgty0Ln0CB5K/LGaXUCID5lsV0Ek7ymHkT8xL7Cyke06y74Mj1+O7bw+O9ofD09VOKGg4cM+fMS4SCr/UIdM7EUtNh641aAAddDc++/9E/fjOSB2gGLLuaDvrZmACBGHGhJCDHrbPwTy6ELrO37L31Oo/kNZxYJFflTNTg4vtRB7o3Wpt9mXoKDHl2jPI/v8qb9PsbuSXbRTh5pw1/bj15nS//ypAKJnnW4abc48BRyV7wfrClV/e867yqNVTThJMDm9gr9pe5WLYDSKLcyoPiS++Rf2d9oYFDo6xFf8CKCFMnqbYaEa7N3xB+duZlGgBjRkG///OcDgIKGAfcCEeXewZ0chIn7iYM0dmfxLqkTRyqyFvTt3FRePD3Jx9bBVpa5RzQRm4qy3JPyrH1SiGtFT1SnqGMRF/9nVmrFyQigIW7RvYK0RLEEbxDu2RwovbUdrivzJC7Al0YjS8wJ7p/eS2eNQwEO0oie0t7OcEEI8TeF8JbtywyKn9AS8GgZ4BVevlcb/qdhqaihfaRjUSGFUGfxNJl34Eta/5TgHBi8fCBNTS71Bmip58Qk5m8a42Tx2F2YUh1sRqjADmGGjfyNu0mndqYAfPTZ77uTsOUGoH7PDMDZoaXVdZsAzwo88B/Tgd/dPAF4ymPZrXjtNg7vLTronjDxhf81Rm13dPy29dEpUigJ3FBqn/YzT5KPjBFzpqVz6W28I5N+spLAkbnjGJgA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFd0bEhMMXdoZlJrdHlJb2lkdEgzd3ZBQ3AvZHl4VEVTeDRqRXhHYks5NU9z?=
 =?utf-8?B?YXVDUCtINWp1Um5NaFdCWmQ4T2d5bGxCdFVFemZQUHkvKzd4OTJkU3p0RTd2?=
 =?utf-8?B?YmdVRzBTZW82QmdZZDRxYURPQnFRMGhxNGlCZjNVUUY3eVpYQzVYd1JiU1Jl?=
 =?utf-8?B?VXB4Rm14V3Irc1pDQTRxWEJ5VHk2OTlUTzdTdnRRWXg3MW5YV1VLTnovZG5R?=
 =?utf-8?B?b2dvUmU0US9xdnlwUDRtQnJ0ZW5TRjV4MUVPUENPbEhzU0JaY2tEWjUrSUp0?=
 =?utf-8?B?NnFJZGZFNGZ6ejJnUHNCeFBsY3FNZzNNTnkvR2ErTkFJbXRCS3RrODJKcEZ1?=
 =?utf-8?B?QkExSUJEajBvcVJZRnhMcHF6MjczSUhyNmJaVkVKZ0Rac2hBSmJCd05ZT3VB?=
 =?utf-8?B?aHg4RndYSFE4Tk40TldYT205M3ZTY2FBdkxHQnhXNjdjM3VnMnBEVHpQZUtq?=
 =?utf-8?B?WFRsdlNXTWpEQTlZelJ1MW1CbHRQQWVrd1paaVJnWlUxRWYzRUNQUU9FelZH?=
 =?utf-8?B?RFNmZnpWYjhGNFZQdDQvdUhtYTdwTzkzNTF0M1ZsNmQya0Fzb21NYzBramta?=
 =?utf-8?B?K3hFUkc0TFk0WmdGc0sxaHcrZjArSU15NEU3Vk9oWmU4TXZybXVId01MYW1x?=
 =?utf-8?B?bHJaalBFMjlBSDM5VEJROHFrU2xlVVhOcFFoUzRhdFZZdW55alBrQ1lkenpY?=
 =?utf-8?B?eUo1U2JCNHZjdFUrYUJjWmlhSWlTbGYwMUdZTDdZQmVqa1FZNnBsbW8vK2Rp?=
 =?utf-8?B?L25tU2wyV0RiQ1Z6cXdxTG5SWVcrMHlIam1GTHJxYXFaUkd0M1ZjTEZPbnFl?=
 =?utf-8?B?QjY4cDQ4UVJZK1ptSkZXY3hnK3lwaEh4cHpiajBYQWx0VFZ4WmQ3L2VuOTE5?=
 =?utf-8?B?eDBocDN3WHdsSTQxN3hLN3lPTkxVZEY3b21abEJRVDY3b0lVaDMxU0NlTnZm?=
 =?utf-8?B?aVZJVHEwNzVPSm1xNUh3SGJtYnVMNHAycEMrQkt0dTJLYUlVSE44Q1IzV2lH?=
 =?utf-8?B?SS9icVFXa1ZLTEdxd011RGNyY3NidkUyd0xMQlhNLzFVdFlNS1hWeUk5M0Iw?=
 =?utf-8?B?Qnp4MWZaSGx4c2lGMDBjNEJxeFFKZlJzM1JLd21Ma3RGTDN5WDBZU2dvc21L?=
 =?utf-8?B?d3U2NGs3L0NoTXc4M201eThNcWpPblM4d1E3eGQxRVh2THI2aUI0TWV4NEFr?=
 =?utf-8?B?Y2JlT2kyallyTlA1R1F5UjdIUzBzVkVkdCtHT0NmU0hQV0ZQVWEwekpiZ056?=
 =?utf-8?B?QjlpNndkakk0ZzVOUnhlRzBLU1gxQ3BYdnN1TDRlVTlGc2s3dFhKMW9lNHdu?=
 =?utf-8?B?clI3bTJrRmh3OWpJbmZmUGNWZFJSR0xXVkZUYm8zZ3hEaTFvRkgwcnM0MVcr?=
 =?utf-8?B?SlRkZ3lvSVhtYXVPd0p4dzB6ZC9FSjhoQmxKcU80NlJzM0duQVN0UEtMak9W?=
 =?utf-8?B?RkJwU1VaQUh0Z0l6THpWSjZOUDVpeGtDdTB1SC93Q2c4YVF3dGFqTzdiRTlO?=
 =?utf-8?B?a2ZTZzNJR09rSGluS21WbS9TN1Nnc3NjNGFlR1JUQldKRDVqTXpHZnZJZlRO?=
 =?utf-8?B?STJnODU4TkpsNVh0Qk4vaXg1MlhIOURSaEhnSFNUU1V6RWdEUUc2TkQxNVdQ?=
 =?utf-8?B?NjlhZjZFWmpBbFFTMjJtNnBsZ0dFS3E3b2JhZjArNXZLYU5ucU40Q2I0ZG95?=
 =?utf-8?B?VTFWa3R3VFNqUUVrUHFmR3lUcktqZEVNb2krcGJHRHhxSlVKTGg3eHd4SFJq?=
 =?utf-8?B?NXQwdy9KQUpOYkQzenZiSjNEYmYxcy9UOW1IK0U1ZWVHQS9LQldGZ1hKSzdH?=
 =?utf-8?B?VGZDc1RPQmp6eERWaTlOeEhCWnBDUDFXV3JRWXRGY0F2aCtJU0EzUTl6Y1pZ?=
 =?utf-8?B?Y0tYd2lsREd6b1drQzAxMjRXNjdlZlVSa29xKzJUVnNONjJqLzJmREw5WTlQ?=
 =?utf-8?B?ekErTHZOK1V5OGhWVjZwc0ZjNmtBVmFmZ2IrZmNCZ3ZEZkJzUndHRUVGYWJI?=
 =?utf-8?B?OGwrVUh5SFh2bHVibVpzNFI5OFdxWUJ6R2k1dnNGNXlKNlJpbklzcXJrSWNm?=
 =?utf-8?B?Z2lOQW5aaE9pTTZWTHIvNXB2ZXhpRm1MVDdlWUdoaHYrSFRoYzBWbUFCSXFF?=
 =?utf-8?B?cmVzd0tJeUNEVHJtYXNNMDVRdm5Bb3ZjNzBVZ2tKdUhsRE9XdHArLytqZmFR?=
 =?utf-8?B?QW16NDBZaGNwcUlXTlIybmRSRUwzRjNtUyszZzhjMWFmVFlwTis0eEYrbEN0?=
 =?utf-8?B?M1lSZEtEVUxLTExIRVRrYUlEOCs4MzBJdTZ4czBzZktrY3V6c0o5WjlxWG1s?=
 =?utf-8?B?ZGZaSGNrSk5rSDhWdTBoQmJNYmJrYmhqcXMzeDFXc0RQY0phQitKdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b93637-21d1-4b24-61e5-08de966396b1
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 18:12:40.9210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95HeaVWKvLnttIYVp96cd9iSp4M/unmFYwCPRdJxbqQML5A3q1d+vZQ2/o/aR2fKcuOc0xLJsmabAD3936yLbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6767
X-Rspamd-Queue-Id: 179A41C0011
X-Stat-Signature: qm1xwkytz4iujaoggry7konpyx91dhk9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775758370-67448
X-HE-Meta: U2FsdGVkX18KFaLlO8C8MHcMPOPPAP/3JUYbkr0gwfIM3DDyK+hr2OudSExXdcxdeenBuPfOtQ+mhZxMcd1/3KInmwxLzdzOcD7/wWUiwl2Hr5KI3gd8civLA3O7uqXy3eNai1Zha8jpbCgKziLsgw5hFEdJxGWnlxXO5hRXeOISo+96sHVtBOe1NjrLujTPvyzrOOxLF7CcFRZcbyEGFq+j4ekGoExSI9d5Yi1d1vyV7KJQcsg69XScbLR4PiOl22vb3l5Z3OP4z9asvFsnca5w21rppYDEGXeAA8U7QUwKzZW0DfYTMjEK1XyenFBjOIpzNDf/OMxqBAwr/CGH+KJeI2KqoidNxYNhxOJp+yV6wS1U5i8Hl07AmMuhj6TR6Euc1c/Wr3jXO8v9ztOCtTmfeBZYTRKDN235kknRQMzhDPgh+B3/Ur+kl9cGr/rDCri40aQt/usZA5Kvc5RZmgKHrIGpgf5wqBVamyEEReBzhoCgPpaOe6fksFKUpTFirppvw0zRMMQ6FfSB2HCKdqu45RdEN7h/7+088uOnwT3LlfPOUD3hYiAoMmRSZUFpmzmQ1e8U1jWlgc/juAcSiu16GnRjcMpQBmJxsYc89Oos7YFtbXB54yJcSkkZfilhWeyaU2Lca75Tj0MhhEk41UqgUomNgNPjC3UsojmIyrSBmUAvhr/jUuYSqEEb6hvVwepm0P5kRSrkZfLm1EVSovdc5dX04I4S8gI9OXhQTmrVImwUcKU5Kg9urfPMGgS3xy7EYTQ+FTwWieGvGEzjxwy4my+HwdKdD14vJ1a85BuV0kP29PR5D73+g1VMNixngbSGiO+85SUT8t1j0KNOQnQKismJCCSTTSzxcOwtwo4rqAonRB9jQz0kjg34voz8Cf8tNgAtZGib1XQi1Y8elCfBJ3v1qPXq1ttdC6m5kbIhWZ18G+B5h+a6TmrVKg7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 11:03 AM, Lorenzo Stoakes wrote:
> On Tue, Apr 07, 2026 at 05:35:18PM -0700, Hugh Dickins wrote:
>> On Tue, 7 Apr 2026, John Hubbard wrote:
>>> On 4/7/26 1:09 PM, Joseph Salisbury wrote:
...
>> Thanks for the Cc.  I'm not convinced that we should be making such a
>> change, just to avoid the stress that an avowed stresstest is showing;
>> but can let others debate that - and, need it be said, I have no
>> problem with Joseph trying your patch.
> 
> Yeah, the test case (as said by others also) is rather synthetic, and it's a
> test designed to saturate, if not I/O throttled by swap then we hammer the
> populate path. It feels like a micro-optimisation for something that is not (at
> least not yet demonstrated to be) an actual problem.
> 
> stress-ng is not a benchmarking tool per se, it's designed to eek out bugs.
> 
> So really we need to see a real-world case I think.

Absolutely. And to be honest, I saw "Oracle" and recalled that they are
always doing things will zillions of threads, so I assumed that a real
world case was waiting right behind this. But maybe not, after all?

...
>>> +	 * Read VM_LOCKED before __get_user_pages(), which may drop
>>> +	 * mmap_lock when FOLL_UNLOCKABLE is set, after which the vma
>>> +	 * must not be accessed. The read is stable: mmap_lock is held
>>> +	 * for read here, so mlock() (which needs the write lock)
>>> +	 * cannot change VM_LOCKED concurrently.
>>> +	 */
> 
> BTW, not to nitpick (OK, maybe to nitpick :) this comments feels a bit
> redundant. Maybe useful to note that the lock might be dropped (but you don't
> indicate why it's OK to still assume state about the VMA), and it's a known
> thing that you need a VMA write lock to alter flags, if we had to comment this
> each time mm would be mostly comments :)
> 
> So if you want a comment here I'd say something like 'the lock might be dropped
> due to FOLL_UNLOCKABLE, but that's ok, we would simply end up doing a redundant
> drain in this case'.
> 
> But I'm not sure it's needed?

I'm OK with just dropping the whole comment. I've lost my way lately with
comment density. :)

> 
>>> +	need_drain = vma->vm_flags & VM_LOCKED;
> 
> Please use the new VMA flag interface :)

Oops, yes.

I'm on the fence about whether to post an updated version of this.
Maybe wait until someone pops up with a real need for it?

Thoughts?

thanks,
-- 
John Hubbard


