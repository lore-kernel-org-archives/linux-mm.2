Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D666A606A891
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WHaqPg7m
Received: by kanga.kvack.org (Postfix)
	id B4F146B05B9; Fri, 13 Nov 2026 15:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFA26B05BA; Fri, 13 Nov 2026 15:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF106B05BB; Fri, 13 Nov 2026 15:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78A656B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:03:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76DF11A01AF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:03:37 +0000 (UTC)
X-FDA: 85431170874.10.33DC1CE
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4DCDC0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:03:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WHaqPg7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794600214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msklUxZA1M+CX4sQQ8uuNswgev8L/HmjGBNvfeRpkLg=;
	b=Ge+HrfHu7N/u9gnvtobern4t3RPzrYwfP0OhNPmIXrKZtZ1vmuCHkQqNeacTKW9y6LuI5/
	s6MTU2XghjX3+O4ZmNx7diPGA3eutnCXfKD0I8pO86NN5dMnvUdRe+LlmxDeOJLyrRb7++
	4OoJmE0U/wsxhXYBwMyzjimUftQDVR4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794600214;
	b=J7z4hDEU210l8W8Dx7PEVzAZwGluu1OwatH9UQ6XHPxvRLCeu+5JIkiDOxvswHK+jTlfc0
	92vrJSI68LwQp+1p6NbEnY5HJVVEMKc0vkxc+/++dGShoV3MPWMQK0lkIMIU0QEgItP9mp
	wptg1U28Os2mwLP0oPMAZjFLpr+PW0Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WHaqPg7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGkGhmI83qGW8G6xfelTrmpgNSqa3i+pOjrQIBZEfpMBXd4YBY6jtwc+v2PAjaJ0F9tsfgknOqsrnv9KM2QBkOTMubkDx6kiyUoikxIL1tEkxIbei13Kipx+jS7NjjCMnCoF/qw3zCM7JEXJ7RrCAELIOQFW2jbxzYHvhgehz284JAswsyIiijHaKULv67z1XKWtSTv9FjrC8e+zOM1tSdY73ylnRFvk/fFFK47bkfN2FiUa8E9jYm3I7dh7iiaAjohRhAow7ubqCJLYu4M1tVu6j7FRPBbMG6g/sZGuIWiHFrGT0Z0C7Af+U57ABXY98/+2fiVk6njFHTatR4rvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msklUxZA1M+CX4sQQ8uuNswgev8L/HmjGBNvfeRpkLg=;
 b=TdAE2X5+uY67aIm0/GVyUFxzqGJmk8VPwu8K9QKV0TpElU2A1Ne9tqRt7tZkEvWl6ykDO6+8NmflE+HE9Z+wAnOGp57HJZCQHJcnFF0fb0ny6cYQ0j6JSVONrL6Ib7uddf/QojdT4HUZizJDm4KmcRUVANAu3YgfOhDbk8Hpg3Th+JiWpYNCqwNHhdR78oL6xEUSm8qn4fRLg0A4Qp8MjcCpZbUI/uqs017lTmBxLzhA0X7B+HKaNhMzI9k+AmT87qCsYfwQPy0CkW+PndqnEfeM5HQHs9DS3uvmAEggLKS5adVBClm0QuycgWD4qt+Yam4ppPxQoGX0+FUUHKGtCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msklUxZA1M+CX4sQQ8uuNswgev8L/HmjGBNvfeRpkLg=;
 b=WHaqPg7mSlbzaXHEZ2XmzXor1z4XSKzQ4mLckviSpdxv9DPwpqHNlIkhAFXVPfWGcS1JYQttJT/vlhVqO4VKtkcMe1BG9E1Va4KlZ3uUlsrscx0kSvkw+sg7npAL/IKfbRXkIF0fWP1YxY0Cdtuz/yCwI3GaE0Qk7lRBdFi9o956OqDqheFDIjv4SOXFqxLmX2T/K+XMyV0Gtv2uXjK/r8Y/j47JNdGzoa0B8bFKJWSUMETxgQvNmChS/cYopTvI0P9uG3/W3gUXAiIri7TUdk2PWd3miIKX+zZAtNbsJzDzuONCBR2eQHp+ADL8tR+6BTuVNJ/aoIo1TRuvMJxsiw==
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 20:03:05 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 20:03:05 +0000
Date: Fri, 13 Nov 2026 16:03:03 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	leon@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	kas@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de,
	rppt@kernel.org, stable@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Message-ID: <20261113200303.GA395967@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113195536.2660763-1-gourry@gourry.net>
X-ClientProxiedBy: YT1PR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::30) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BL1PR12MB5732:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c70baa-a9e8-41cd-932f-08df41c12136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|3023799007|56012099006|261026121527099003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	MTETyMA6svgshOe5CyFhz5injvIjfTxBmsE+bPXwfET0y8wkY6F/NIkhELwe0bFXA9ixc+lYPUHikAjCkYmCRJ9ahkiURI+l6xL5biTLG70jfX4Hm+g50rsnK5BTyJszfzwCjx/8wPRhejsmsqsCrO+UehwI7RSasOuUSpXWqbSuCHb+GXizbPYczwl958MXrZOid7Ls+NySOykMs5jttbhHU3XbQ/fstz5ZVKWHCrx9Ltfxk2oLzZGgA7gPtTpCF4b7T/8uQC/cqYQz5rFrSLfwSw134W2KgIQNjBMQ77qJ+Pq3MbFR6N9DDr3BTi+kMXQyFcHkI8z6/4+E/zF9KMEpoXK/bV7ge5jcWhffUQ9hjXndS0tG1rjvS5wlYdz8v5xkorjifhItqVHL+XlShlVU3izAEBqoOnSY85qIszkZ3nlGr8rgUDICU384UkhdNc+b7kvXoplAz4eRy1tOp+eqgO2+xA6udesLqyPeLXtz87CVUYNnfan1x+TOUaS/2kuWLbqf6R/RYpMjto8HS/OoBP4UDmtHKcZ+8rOtErfcxI4nee1ma4+6kDYT6yEC/6Q6pnHoSa78uW1+xb5EThIb1Y00m4xrE8TEX/cY+0nkjyXwH8kqZLvmesMlGHJbPWkp8KdQTckR510NZ1coDD40JSnu4/QI1Yw3E/oN98o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(3023799007)(56012099006)(261026121527099003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vIOpdomXA+76ySEZkQ1GnTlI+9acNpZ9Pm9E+3NKraI/h3TqD9gFHDSEej8f?=
 =?us-ascii?Q?k5hDpjdrsisMixW8s8KHNgC+cGc7lQltfpC0RKc1cs3tjODoYaTqWkgkKkWz?=
 =?us-ascii?Q?3tm0ZC+41zkU6QFO28pgMkO8XqDW65dKV0O8pjihMNsbAvTewPFARWrr7N1q?=
 =?us-ascii?Q?vhO/uRoxCL/KsiMwBjlBji72DdCMBKvrz/rfQjeg4LK/EgKZ1K5svInOfJG9?=
 =?us-ascii?Q?wY1HkIC7/doSB41vMgzVIe0YMhqDYV3NEQ+ZWaRt6yK4ZGb+mKPZL11XtMRj?=
 =?us-ascii?Q?JP9ZX91zMJfi7DAev8bSft9Stn9xIyPhVQhjVia9OKDX5cf7nESUTsZcYLUP?=
 =?us-ascii?Q?ZIQKWCNQ3Ix9Zs7Fe6/fenlRlYZysMYsrRbAcMeFYg6dOCI8vCZjfdBJlxsW?=
 =?us-ascii?Q?GdccHaf+FhiUsFtjrHnJyPUwenCXTOUUaiUpeC3CykDbncxhRRlbXvMTzpIG?=
 =?us-ascii?Q?geResm/m+6kiro9NhqxTkaI0Iza8cIomqGUNNo4arKEkFvL8f80IqRGKfZbB?=
 =?us-ascii?Q?z2Jn0GnjMnorrAT92hH9NXIUkxuvOfduXtUm7jTY5yO6YjQUBPwgYF4ucPaA?=
 =?us-ascii?Q?9cZVL62mp2fjUMj1C2y+NGxcCaBUvHmcdRcG15wdaLWmaiZ97/qWDustZhDq?=
 =?us-ascii?Q?rmPMZ5nQyGectIOn+qMe0zIZEcmU22pPy32Eij9B9tnaK9bOeAH4qXOFlrUo?=
 =?us-ascii?Q?mseIEzN4Z9b36fAkBGnB7WY6UB2Qu3Y2jQjGMOzcs8oojsatPWIe8PCnuJZM?=
 =?us-ascii?Q?VyeTauqY2sxa9Uo7PAzBP9JY6KlHJuw6O8RXBPDDqq86H1rPR9Vcian9GGDJ?=
 =?us-ascii?Q?agn1SCBb63NyjJo2ILFauS0p2DLRDkZtn7ot+1Wlj0m7zLD9uU3d0LZCCxKI?=
 =?us-ascii?Q?1UFoblZxZai+bqAn9BPYQRCJ795pp3sFyPr6+F9q0gFjpSSr5cdTV3fkQwLk?=
 =?us-ascii?Q?llBfMSckKXvZGH7reK7p7Ddl40CuD+ErJiee7HQ59MsmurfdDNIb20hkM3lR?=
 =?us-ascii?Q?pr6ExP3oGCHTdT6MWJAl7hzRQhO3AjA3iYBfH9y+blt8J42u7uPGS/ADi91z?=
 =?us-ascii?Q?tt0p8KXZlGbmeTOR9rcR88T776izlueKOsiSls/Fr+68h//kgdM3bs5S62UQ?=
 =?us-ascii?Q?CzY77cXhCHTHjrdqC8V5iy+/vLih6sYeTLq6uARu911J2bVKEhRpfdbrN7qw?=
 =?us-ascii?Q?prRGPkWDAIruNs3rASwz+g+Ys6gm/vuMRIKUjNHbhJcnGnFv7Z0lka2pDUNA?=
 =?us-ascii?Q?1C7OOWrFrg0ilScxscKyoLsXlKbBUBl1491vfCh0J85jZABwxTqFCQ9OzbUm?=
 =?us-ascii?Q?7Epn6Jy1kP3bPHsEfpDGU1MmXiXVxYn6FicPhTT1ls03LW4hSO8eSKhdI1da?=
 =?us-ascii?Q?TO6AoZ3DR74r91pxZi27VujUfoMZU9TIEOI+rS2cGE2GYPI2KtP5vbTTu/rN?=
 =?us-ascii?Q?a5t7Va8InUYv8JMaNq020sUZ2NVxwxItAtQoW+SJdcvvXcuri/QwP7o7tJxy?=
 =?us-ascii?Q?FeEo20bm/5543arfTI/cU82fak6vedC02DCG0D4TA/G65HhA+69IvUUKVMgN?=
 =?us-ascii?Q?JbUPCpjjUatr3I6wfHYE0cV8Q6rCe5MU6Y/EMWBU3HZO7xBk2MKmhOl64E6+?=
 =?us-ascii?Q?LPKpjJXFuZ2apcindUYfUixgPSFUjD3Sbvxbkw53e8kph/D8z/PPJUvYO42H?=
 =?us-ascii?Q?nvmNCJU21PmCpYJnJO5/GsKpi6q/y+1F+SNkiPLjwZ13k1q1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c70baa-a9e8-41cd-932f-08df41c12136
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 20:03:05.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQ9YVm30fvigh+aD9tF6cawEQZU3C2V2IVws70thKvtrySZNsaZDLfMfpXh5/8ug
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5732
X-Stat-Signature: 88rkyzgd4393kcfb6zqhpyonrfaqrrmx
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4DCDC0005
X-HE-Tag: 1794600214-987672
X-HE-Meta: U2FsdGVkX1/XRj446OzD6ud9b4dNYvwl6I+bLmgqnvkcBnAD29L0ihZKtHAXzclyqARjTrrLOUa7FiOCqrVZvCYD8zll1sZG5e3Mdm8d8Ts3LmJLBxpiuD6TQTtSOSvda7yJ6Bi7wInCYSoaf8moFmh8VNGYt7AWDxBDMQx8+ROKDhRYW2kxdrvpkcSEXS97/JUM9Ql3r729HjpbO/LiQ+HeKPFi/70av2GlWpC8YnMatLJuo9W540CAvKNYoCOxTx6n2oLLJZSl/kLVfhsjlcydEcQkIxI02og/a6D+LnvDCpjHoQn21aPamYsaSjPUDwbVN0H4enDMLUEJE4CRp+fGrtuJKMP3e4ti8T6eHytXQQc5SPBsZCFw07acX/NDHjqSU6cPZYnDD330GB5v8Dr/UWk2Hsbu9lZKEtcXYTHdKGVScT/zYSEuGJL3edRGPaeN1hFi5YvMNrgyxmYY073ijLI0ms3vrbbA0uXZF8Ft3m3XQD7bD6NainfsBcul6X3hmY4qiy9fIF+oQTZP6k1bHhWbWQ7sK5mw/KVespaq1zCkDsik94Et1tmfP1qVdHkRgu79h00vhC5nyjqVw2h6OiV9YS4KI3w+AFcxv4KURwuK5SYpFu/gPft84CgNc9mPwAaBt6owcIuRxjj//wwYutcTmdtmJZLkxmQlcsy7Q7ygrRJtkpulRJaJSHwgWvzSujbRN4/w0akoTP+TajTtaZGEkvQw3nO4QM2du339cS19xXRZ1uftWCll7AfczlBFLMrTc4ewePUA1WR66ZOa4oT3mG6o56MgfKE8kQ99Q7SED9hKn98cURSW+Jt1xkYUv80Qc+TT0CjxyDx6Jn4p9HhDElfnpca4aH6goH69VXMFQ0686wdv7Y4b1ORSMJK7fGrVCj0WIv6C/IvWLlLT9CIdik97exKOaBYSE9MhNlZmuDik13wuubGFJ+Hm8tRvOEwsGuDf5/djP5N
 yP2rFEXK
 uHPTZOAXZfNxq5qgVvjexfGiPjj9k6V32i9KboB7YuDyArc7ptftAmUddkiDJRCjmKTjEJ/lQaVd85UEx6x5sIo+8CnmGWbYjT9HkCUP7zvZ+RZDQ+s9SWBqxLIOzNv4FQII3ftw+wEfhlewTptJyrCqkCf5nO8SL82b9AWfRk+enrmaI21a2Fpk/v/HT9iAhyyIYzWCrzD0pkVbPw/Y2BcfnPyAGdRCfzs+dkKrTQTKG0P/bi+IkqozCT7m9lwpvMBbfjL80Na3h9DBi3+Z/Hl8OahYA21+T/GwkBTyXElwcD1dUs52WFxBe/YfknzRUkZlr7gCBw4KUJFGTBbA/scKLaQ455TIGxuBDHNAtm2acXYFOpOJDohGhqeQH4V3ywGjYMO5iPobvm8vJ5Sv69+RsrERUUSDrEQM00CHYW89jgDbkYSCaHIiaug04/b9WnBtB5qdxVxePm5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 02:55:36PM -0500, Gregory Price (Meta) wrote:
> HMM can grant ordinary device write access to a userspace shadow stack.
> On x86, pte_write() is true for a shadow-stack PTE, so a populated page
> can be returned with HMM_PFN_WRITE without taking a CPU write fault.

I'm not sure I understand this? The pte is writable but you don't want
only DMA to write to it?

Is there something special on x86 that makes the shadow stack pte
non-writable by the CPU?

A few more words here would help

Regardless, this seems reasonable to me, there is no use case to
write to the shadow stack..

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

