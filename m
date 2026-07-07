Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C9BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BB06B009D; Tue,  7 Jul 2026 19:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B2E6B009F; Tue,  7 Jul 2026 19:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BDD6B00A0; Tue,  7 Jul 2026 19:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8AF66B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:26:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1168FA05ED
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:26:57 +0000 (UTC)
X-FDA: 84963568074.25.F416AEC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B53840002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:26:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UTHs19tb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783466814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYSg6JDR1EFfLeYq9FISxLpTFNQ1rqHmcATlAx8twYY=;
	b=cAcQDWr5oYN3AoZFbd3e+RqNSIX9LJgY1x1yWvRLUTkR1ZyWkDHqXtnb6491KpCvVjJbvJ
	ZsddFZuHZ3LDYUFeWqMt0BKCujvhUmr3v7qmeXbG/XOY4dFAw6GXCCrHTIY5LmwX8tGJx1
	mLh3UVNDE75mGPLA8GhjeOX+PBX5GEc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UTHs19tb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783466814;
	b=kX90/na6uo5MlG3sh2IvDeIpf+Hg3BM8eaeTDJsX4Q0RMis3QNtpKFOF2WNkyk8jTx1BGY
	cb2j+XDW0aQDzf+CIUXc+VtTSH1nr0V/k2wYOlPDYf2ahKaJhVpu5TuwNM652lS4WKp8TC
	E9tgFw7XZCI5LtTl0AHEXIoWHwGkML0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uspfRgevLz5UAFFnQCIvdY2KjCPoTH2j3642ynzV/1dP4MBQKID5fLAwSeI/SHTceXEYxYCniqudcvZn3BiEkkeHNVGv/G6cDzU/vJ7S1yIGClK6i7r8OeUZSZqzLEHSOBQsJ2qB6EblQO8107d9UQSOmDU89AEcRAmE/21GD+ocDY4IENrxKlFnc6Ecpsr78laWM0SZSevuBAvXve+IKe+eo87akTCxsuIGlRfJ5aKckEyRcEpzQn6RsWb3A1GymmAUjqB+lckltkPzOc18EA+Xfk0oGjOl+s09bUS+TrU/Zlx+RpI8/zUW9fN+nWk+1mlMdrNBz52i3TgzwgaNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYSg6JDR1EFfLeYq9FISxLpTFNQ1rqHmcATlAx8twYY=;
 b=QN1hBvOhP4QBnF2HkuUdBEAQQ3m1lMy7fojdh+i48CuWz00CZNoHtz0cwr2t4voxf3H3RVm3+/+jxZsx26Co3VFJdwvXwaBHbQeGyWF+45VRElQ04YMsedNL8stve3x/E/4CPyITxUPOoYP1dxfAnl+RjrvuBfQ+DqBHGlLGr3hTYew6rOqm8rL6mlDXeLzpfsniMCJvC36cm5FekUJ5NR7DYkWrv3GBTqk8xA/+ieo7VEqvRbuIevx2nWMjvsi9lvX0NLE400+wYZ29eTLJmjZbzLOu+3jqGj3nV2KJskWqFdd6iUsNjtilSXamCrufZxyVBHqNftyqDB0y34mINA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYSg6JDR1EFfLeYq9FISxLpTFNQ1rqHmcATlAx8twYY=;
 b=UTHs19tbwXMDk1CQNwxMMosRv76GRvXh8XYqRy/5pQ60Evp6VOXLRsfLySkNTc/c7rEsKGqESPUisxXyeCHkzzaT5OFDl2DggBhxNoy4/enAFgEh5zMU57+UoR1XSAxdDAiJhmULVKuvKq5Gq7NVyM1jW68abq1tf39ErAGRYS/1R0zAEm50LSlrWQx5q+YTEHKW+htIMsKiCn0FOArMZL+h8+cYc27wzXbKzFeQp3f2ofP9F3mWDcO4p8806+MzDKEo3dcORqT5maV+wzE4sBQ/3Bk2UAvWAxe0HSJYxoUQF/Y+0VKbwtFxHWuR3ZDem0PFpKwquOEBGw8zezBufg==
Received: from BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23)
 by SJ2PR12MB8740.namprd12.prod.outlook.com (2603:10b6:a03:53f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 23:26:49 +0000
Received: from BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2]) by BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2%4]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 23:26:48 +0000
Date: Wed, 8 Jul 2026 09:26:43 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH 3/3] mm/huge_memory: skip device-private PMDs in
 madvise_free_huge_pmd
Message-ID: <ak2FYuUFnPqtXzzf@parvat>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707135255.292870-4-usama.arif@linux.dev>
X-ClientProxiedBy: ME0P282CA0121.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:235::28) To BL0PR12MB4995.namprd12.prod.outlook.com
 (2603:10b6:208:1c7::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB4995:EE_|SJ2PR12MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: ae18a7f5-6400-48e6-8de6-08dedc7f3779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|7416014|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lg7ytO83u98QViDE5NC7h6IdZ564QOW8Yslk2fFvgFeFCTTsuT4m//wfli9WBpi50aElC9Srxm0fDRJkHrEcACwkt5HxeZGFnJ0KcvjmYuIlzuXpVHZK9Clxz6tTHnwgubbsX2IGSTUyiB7u78cH720im2OcSkavYdWGCSrQ7gYdsbOYKADxKmxQQsKV/quDKlBigWrAiNMDUy8SBEtIArbStnT0rIoxeWxDa112OVJc2PWNZCzSHbIrhZFKETzjw1mZQ2vdiOoub2jTd7ZS+fo8NRnkd4lUJNAvuum2c3fh5QP8Vj0TyXO3fZTFDwRD2YGrNDhcWpACwr1ErWvi9+IqkIDRejOkzhePcpNPgeISsOcHYuOqT3aP0Oh5IPg3gfOVsk/qketQkRq4lhIHTXs62/g0//BoY3vZ8gHGr6oNROyKP5UFWJlOMZOU8RicO7HQulKMc6yHXu99HrjqguZWb88j4uO63WdziQeUZYC6e49K07ZpAdVj4q0dG5QJ3W1sdoR8PKNGW5ZAd994/c8pp23gFsk4kE+77j8VrN44XP2GqCsZ7YZC4lwKlMU4oG6Q8TRReL/VJMxsy0/H6tKMIZqX2sTeN6+4918THi2Ge/Z73Q3BPodJxOpNOwdBNFtA0KxkXRNuY4gntSTiE6kF5aHl1QbD3W4lg4iLyb4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(7416014)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YH3RilwASZDR4f7jaoOMJ/ORoZ0Co6qcb6yOdYYL7hzGvcz8yp1yTLhXv9O+?=
 =?us-ascii?Q?6u0Gj2pGW3zwUoMcFQAq8UhgfHHBP4FT39cxtwsudhS28+dTbjGLqiXQyfzR?=
 =?us-ascii?Q?M12FesQuzHqpCmZEzHTBgo+FrU2iDvMVMu2oaZxbI85/8210ivwv6R4SiRId?=
 =?us-ascii?Q?Es89vkxQ1mkG4HepzVgt8RWkBxk7Xjmh5zwPQebFe8fPdUQ32mvT28hkm1N3?=
 =?us-ascii?Q?pcHNhFSbZoEdmZSryiY+pkixYdQuWJFw/wn7VrUspY28y8KDpyCPBfK1MRFg?=
 =?us-ascii?Q?YnAsFR09N2d5koJWgwZ3XeQrNLFbYheHjo/rTnFo9MMk/kyM9L4SRfSFJLEi?=
 =?us-ascii?Q?Es6CVQXwqsYSopHLwFNuOpqRYtMW8ud9sZo1IN7GiDzOUme11cHMLccXZ7gb?=
 =?us-ascii?Q?bretFHC6uL9vkj2kAefGKZby3TLQ5JRvf9Ff1pXxoJFarOlXGdn5pLQFnG5N?=
 =?us-ascii?Q?uNQ8+u7nNs5rOvjeTUGeOH8DYEZW2zqN9YMIl69Ydxu4PcoVuvrvV7QojYgN?=
 =?us-ascii?Q?PyTnnMq1nfjkiQDvPHpB9ZVBz1tL9JpfdbFGstQh433qNh7BC8lNncPDBhZy?=
 =?us-ascii?Q?NLVdunA//f376BhtOlQ/cL/1IFNYLIY6NSukIx3wCG/Wxwp4fjL/59OlPjJ7?=
 =?us-ascii?Q?66/TAwsB8GVZIWBkqcGLbjJ4jYP+lj+H0GA4VOgdKaJ8a2yFKPiZeTRj0KrW?=
 =?us-ascii?Q?0QhroCo71dx1XySWyrFDDaj3i8ZcSB9EECY+TxZ6KP0yP1ihOJs35h8rTTrd?=
 =?us-ascii?Q?NPLrX+Lmuc0Td+ohhJKm3bP+PimVK+roa//q9Rzgy6PUifqZC9Su+XOAaodu?=
 =?us-ascii?Q?UQYLK7CoRTbLjhrvLVpAwtHwku6CvQPn1wyfysFQlEg0brtd+FGIiiill7R+?=
 =?us-ascii?Q?ot3DssMg7IJ4tA0xVr2vprO8RFFzuD8tCvIcDqzqKhZwDySplK47JSVITqMm?=
 =?us-ascii?Q?poKQIoiUG8biEt04wNp/wUjJlbmoiPYZkK5mnTbWUaOkhqJzVA/2MbiFixm1?=
 =?us-ascii?Q?Da45EPCzgrOEcYAmvfsZfCz6sXJW/dcKNwX8z1sQCILU3XB4q6+rlDxa9wTg?=
 =?us-ascii?Q?2pz4gQiGpEO/3PZu++7oAQJu0N2yZhW5/qPGxrSISRonfdnmA1NULbJWndhU?=
 =?us-ascii?Q?X5csQxA67W75TO12CtfZrLEmxW7IAEHgd7mNxbKVDr4CMn8rV9xyAWiuuR9d?=
 =?us-ascii?Q?sw8ECWoySChfn5nVlRXm4WULmJHAIjKoq81OL7Uw3r18yZ3UsdK8gVQXntfK?=
 =?us-ascii?Q?TqUrC2RVzsLMosl2Q3I6UscR22MP3fcRzEWp5fFs0v3naHampkxu6U7hpbA1?=
 =?us-ascii?Q?N9ciA0Zj6zrwwjbD8IYGl2yvsAJWncvQwrtVaV7jQDcl1Vfhx9UZ2tgJtKwj?=
 =?us-ascii?Q?sLxsduOyJfu6MGmZf6GNcaIGhVA0ysWNwvBo4SkpDf+LuZU2LLhksHbb9gNN?=
 =?us-ascii?Q?YJJZpkw4+q++DGDiVKYav8wPNpZFNrQn4UOvfK2+1grRaNXIHNEcPThFkJOX?=
 =?us-ascii?Q?4E8E6k6bE43T6Mrwjp2psQXfZdyro3IYor7Nb8251CSbQEmyAwQ3ncBNMNa8?=
 =?us-ascii?Q?zTnrg+LKZvRtPq7fYOus7fZSI4pVRtlK9BjSu8/mQf6I2TqLjg2EbgDm8c29?=
 =?us-ascii?Q?Pwx3TWRT49FR6WB5UOhgDYos0SZeDdfIkT5vLtx12KzXVx6VTuOI4Vu9Q9Wk?=
 =?us-ascii?Q?RrTSl5srIooyx5/YlwUomRDljGa7irGGLROtvz7AX1MbuC6LI8RJlUkF1ghr?=
 =?us-ascii?Q?DKjK+SN9uA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae18a7f5-6400-48e6-8de6-08dedc7f3779
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 23:26:48.7730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NuXHOmG9rSMyfLB1Xlt51LQ6HfYyYsamjSd5Zlde41hj5kLmbsaX7pHa2Dja4Iy4yZIUXRSD7xwQ1iwcGC2Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8740
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B53840002
X-Stat-Signature: uk9j9587erayupmbjdxsd8x5dmh4xdgx
X-HE-Tag: 1783466814-806573
X-HE-Meta: U2FsdGVkX1+b4lX4FiltxMJbXpUjURXiRpbTbIxco/x6cDCi4TXjCKHKb6auIv7ZgPp0cEkd5EBBXoIwIumFoVfMp6C2yVTj4f6Fr6rc6pQTPQLCnZ/YqgYMWh1sSZXjxOeF5Vx0/EECKxGqgBp0CQOrH+yIf4mx7yVebrxjW9mF4s3oY89XHxlL3CVdKR9SpYBhUR3uf+DQ9LLSrhSixl/vD67k7E2K5X23dWUYg3ZJ1M0E2sFTyna3St6Gcsy1VpU2qqyRDcIgkehvp36jS7JNbB8DY3FtPOcUD9Pb+2NzXP93Dr++zHQyl1dM8jr1YsjOB2kxp5s687UeA3zji9CVVtjnYuzqEIsg0QNODsL4t7MzSLpvOBYgn5jAHrb/p+tj5/aoxNPGHSsxWF2JXZz9OXCRxeyvtdnnyLPWwldpeAR9HhuyvGCik6/E4/xgxluiKXYCgy0/ZihsDaRMv3/tyOHzmCtgxqD2vInJytqQd2tDUrVJ27MP0+n79NzgspvNvS4LNtJaI9Z7Z6oNr7O9yKltR3C1St2Ai24P5B9A6vaE8Xlm1Xj3hgJp7YQ8SKyhnmZ6dn5cC1MP3P7IAxcKbxj9kEPVMy6w0/WIbVLFmOyr+T60TOak0ZuMLW2gQJ5w7t5tEhqPtWxiv2tyME8tqeiWlzEfxgLEza1tuh/uS9gzpX8J5B1By//3JquyfO4ZodM4IWqF4GJBb19YKR7++Gv3mhBgl5jn66NWenyVDcz3emFDX0suJaiXDu3uiq0JaYsjDUiB944tacPiCZm10xlFv0XRZ/lfJ8AsKRN/FufSfaclRl7kYftpNGPPrdUIafwTi3XVeHBoYZTVS8VQ5FRl9lE5rPOQkrBNDvaueV1EB916xmIUKqJyj9QHUXz9bNsEKEiJzbdNqhoZuyAMepIQRieRlrKWzf/QsTttLQaZPwfqhIVju8j9ksI2TOZ2FoslCc9wzwDXBm6
 TJN0gY73
 it7Yaa04bYBaCXVr2/P0J7HyoBA/j3B4qvuVhuEhJH2SRKKn0eBt3NlYPAvH4xda4xbRbXmf26GhdaWzFH9ItoIHrYb1T8zb7gblnUVT5wlL1mWJgGK7l2EuDR84eMtV0DoJVThYX45uAlvG3fO/IoPDqDqHSZdnxEjiiJH8BixvtqeSohJLK1KIFhXkhGmzdzdqey5zbkGN7MqMoYpyDqrIg1QWhcyCmTDxn/A9EH3fotPJEMOm+fxGXYtmdvP/n/9LDvVWtoLYM2fOesLAx4SV140qKdFlvJNkEXNNHtDSorUSLKAb044o/yYZiPQ2eewzq4pDRseePIwesJfsviU6E3ge5necKR1f6k7LvG8TD/eiZIfIrXQLwZW3mR0GCQFZFWSmjKUtwqCetPvmOKXHAs+2rZ1JqZoPA48rUe6Dr76xym+bm/ltmkfxZtu2FLMy2PiDGodlWvXMpveBf9VemB147DYla0TgODo0ijD132/WbHDEwGshHJE4FBwrfMyFUVnFtIBfjmOZz8VotIEjrEeS+UN0IzNNo6S91szyN7KfMzpQQOlJr5nfQ0cdl1Hg6CreLl8Eqrvat4Pxt03aY/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 06:45:09AM -0700, Usama Arif wrote:
> madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
> madvise_free_huge_pmd() takes pmd_trans_huge_lock().
> pmd_is_huge() returns true for a device-private PMD, so orig_pmd can
> be device-private and hit the VM_BUG_ON() on the !pmd_present() branch.
> 
> Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
> migrate_vma_pages() flips the PMD to a device-private entry between the
> caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().
> 
> Skip device-private PMDs after taking the lock, before the
> !pmd_present() check.
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c0892cc533a9..cfce9f31b30e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2296,6 +2296,9 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	if (is_huge_zero_pmd(orig_pmd))
>  		goto out;
>  
> +	if (pmd_is_device_private_entry(orig_pmd))
> +		goto out;
> +
>  	if (unlikely(!pmd_present(orig_pmd))) {
>  		VM_BUG_ON(thp_migration_supported() &&
>  				  !pmd_is_migration_entry(orig_pmd));
>

The change makes sense, I spent some time thinking if we should make
madvise pmd free work for THP PMD entries, but that should be a separate
patchset, it is much more complex and involved.

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

