Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C1D606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=F4Sh6Qkg
Received: by kanga.kvack.org (Postfix)
	id 8F0C26B05B7; Wed, 28 Oct 2026 06:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0AD6B05B9; Wed, 28 Oct 2026 06:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769346B05DA; Wed, 28 Oct 2026 06:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4546B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:02:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D73E840AAA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:02:42 +0000 (UTC)
X-FDA: 85371595764.17.3D84F6D
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010010.outbound.protection.outlook.com [52.101.46.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id F384F4000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:02:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F4Sh6Qkg;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.10 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793181760;
	b=nGRearpIz6OGDWC+PXSGn6EU1PjtvKdCFwpqCR0DzwoDl2ECzjofHdWcNAEbAJJD8mFLMn
	0B4/9cTZpSM+MI1ETNlRLk6aW1lFaLRCls0ZrkafjmENgEaD6GAKP9Xj5UsT2nY3mGHH4O
	FOVYFIwY7sP01QHQ9Niz4Q0066Tm8GY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F4Sh6Qkg;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.10 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xwu5xDcFrvHWZBCT8bp+GJfHpCrH28IBTd+F5xEqNSA=;
	b=ascCO7csRybLi+6XE+8jkYXxEM9rrEy3g2Na90vD2IYFgSPxzQNiM5IYQUkkez8rWy7+ok
	5hugADdn/hGluB7WI4HmximjXLSRBn3HEsHzT5p10TgJR629yYQ764A+4ScHlUJ/zhxvaP
	LALvnvs2X3oJ06uuHB4uZFKCZElwWdU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=phXOmGvXVZPswMGN+bnMPZYKV4Dm3mDTqgwTcye4VRIs6qu+NpmxoIc5FnevToCNAGHU2Ag7ZAFyrQq98LhQL60FkwhOyu7RrqCHKgjPh3a3DVmUqGiCot4nsFa/YtCyVkKcJlLI0TQ27Xjh6YXpDb8oGABFAIjbJ2wg7YFLsf4qAC/q74TGDXA3SrOf/rgdygYSQgfgV/jvJPyiy65pSv8RihbWlSO/4oQJ7pMckRPaq8YMIgxvBi9ueaniLXA8mNQFxhEJ1zPkfAadzTq9HTAHJm6HMQxamBvUYwvBnKeeWWUr99h04CvPxpTBQx5ZDfhFeechy/HCdXyQznwAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xwu5xDcFrvHWZBCT8bp+GJfHpCrH28IBTd+F5xEqNSA=;
 b=GmvPKfaGoN5FVw7aOjjjWJKTioMst6vVpGoSYOHcyjnoa7+oDd+aiNeUvtghQogCLOCsn9qyRS1gSYmf75rtKBqGqgjPT6o7aaAqLe1QA1EmgXqoLjpqWFTwdFUAFIolPYlrC+IF1z3J+kz+a8ec0jkQF/tc8Ih0tufB6Uej1uLKZpOh/gnZc1UQjZNH4NmVbR8qEzjavHZ9sJLUP3XHSB8ieyrzFtyZAryImePcIF/Y6RgubeXavGe+7qW32opPhiXnUYikr/4JczUREPihrZLBMCwNuM+oPcVKaKokKcxAvkDp1U5uKBaiBAdvaGL3l/i0cOK+IoF44YrglE1YZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xwu5xDcFrvHWZBCT8bp+GJfHpCrH28IBTd+F5xEqNSA=;
 b=F4Sh6Qkgo/Ku2L+0pAyD5kw3KMunUJHy17XW5kFjSgJOfu0LwGXc0aDZkCGqWUJ1eVYbnKg/MhRJjK9Hz57Q5P/PuFtu+kF2etJ7pxJhupoZJUHjHSk4gP2JVOyyjGXqREiPdu1aHhLBrVmK9nVzrlx9IfKnCwS/A0/jqdHGEuLYuRMkh5fEfpR2nhlbIZ3n3Yh8PGfyQzdOlPeVol76Fc91Js+q8GmJaKwWAHOvVZsKgAhlM8Ee80ikPfW1L4hwkreWVPKyDjP2cJoOVlfEkXCgO9W70Vy6UH1qeeVssZGQHJ+ybrNuU0twn0YVsXsUNu03WfZ7Qnc1fYkvFlspgw==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by IA4PR12MB743615.namprd12.prod.outlook.com (2603:10b6:207:150::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 10:02:34 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 10:02:34 +0000
Date: Wed, 28 Oct 2026 21:02:29 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Stevens <stevensd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v3 01/15] mm/mempolicy: charge shared policy nodes
Message-ID: <auHINbCObZYzpNqC@parvat>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-1-4ce3baf2db4b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028-fixes_shmem-v3-1-4ce3baf2db4b@kernel.org>
X-ClientProxiedBy: ME3P282CA0097.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1c0::18) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|IA4PR12MB743615:EE_
X-MS-Office365-Filtering-Correlation-Id: 74555879-bc07-454c-a9ce-08df34da96a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|261026121527099003|11063799006|4143699003|261022105027099003|56012099006|261021135927099003|261022075727099003|261021121427099003|261021123027099003|10067099003|18002099003|22082099003|6133799003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	DO6IQ0fWjEJGjpHqEDRXmX9rtm25TaYXGNQzpsc2KRtDtk7GLp4hgWjOXnE/b+S8iac5zQTn1tMU0w1GMT7Uzo32NTUXR4fJmSvMlMWdywpQROZa60bL1SOk5vekgi6gMNZ4/FI9m6Cbf3yviSSfMVTdPuW7QaZ46ldU33xweTc7L+obB49xpSXkfiE5IfLEaD7NvTmGOhGnx0gs7PcP4/J2EYjl3TimlBuqhqkGPEyFGMqKFyC5OL2OCja3NvtwBERLV2xCix0WAdNMJDydS+cOoHUnDbKtXhIMeG/1chxrAnY7HuJ1hjG8O9/rZu7Zic4wk/8+VrY2Ag90TsG6MQLO1Rs4NyoOQKh7PZL5oAzM5T3fglXUbyr23QnPNzfr/P6g9Zn4EOxA+d6RSJmhNSSH4JrkzXasBFLzwA6PSjRbeLcOHdugp4Mu+Vi3ITk1GZwT30EtT2GatEvTew03wTbmVf9NkzLH5ZGjgGo75nkLBtKF6fVxA5EfY7EwFkbso2oj2hJNWIJYDPHHZVSwx4lwpk6/4h9p5Muh9i3nMHCeWrb2QKvB1xObdArAGpg+P/WkC6dtehaL9knylSa6/jFtB2TPwyFr6bwJAKhcAgRg6mVttMiSa+Rgk+R1oiO7dT/cdzsIB6QX/DSkfLAWoCFnTxEaccA4wPWKDIa6NiE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(261026121527099003)(11063799006)(4143699003)(261022105027099003)(56012099006)(261021135927099003)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(18002099003)(22082099003)(6133799003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bJWfcahnGqRlmE4KCIQXOyeLnWAzz5f65bkmG0gcQE+2m2qG7WYiz4oZZpb6?=
 =?us-ascii?Q?7JYmERLlvrzzKFeuiHxVtfZ+ZYM8Bs6nZC0K29h40Jcj/Tv3lfrxcFbjyh3/?=
 =?us-ascii?Q?HXWnTK9/WuqajdWhd3oLNDFzmpHx8X0Dn7p2qpmmYDhujD4NgTkI387cj1k+?=
 =?us-ascii?Q?j6qpbnsTB5PFnFtiWvUY2vYRuIKwNQLiujtGGK8Isc+RYgHbxm2/7mF2J5Jx?=
 =?us-ascii?Q?SJGjCB/mhe9gRerh6yG8x03HtAO0qA4TyaOjVUptd08McEutGWBEaOcJ5n2N?=
 =?us-ascii?Q?eUCaDwANSvszfHZaXopOp1KZKJ1HLmuDysi4byyKNd+bv79dKQaViWiufzmm?=
 =?us-ascii?Q?grblS1iuF/g3mNknW1ChVwFWrXVva3v6iDr22c17OFS+IEl2/WnBNTl1i307?=
 =?us-ascii?Q?sgT68S6kijNQDUjjM9yrFNCULzRrV32ZglTeABHuXDvugtg3RKLLF8hLPoTY?=
 =?us-ascii?Q?CkUUU2UwUCUO1Xbs2s6k8yli7DyeDZj679ImE2+C70e0C6ZEZcaC3RetmiTa?=
 =?us-ascii?Q?b/jK/p9GdfpXfcubihdQ7OcXF4p3yLb9moXFf301XIhNjObXNRz/nH00OthT?=
 =?us-ascii?Q?Fiwj8EZpJbKGbl4MANEKgwGAAWTW06FW6dsg8J4D2kd5bV/j6T5pxOnJv2Qi?=
 =?us-ascii?Q?W0rSCA72FVmG8LqEGE6bhfRjAB2kq2mR8XhOK2FINz4b08Tlhg6oy6gPzj05?=
 =?us-ascii?Q?5XqUoIEeNMSavM5AbQ1ifnsx6fOAZBbWubNUV4qAjM5pX1EIcb+mYncnSDaM?=
 =?us-ascii?Q?JiYijb4S13Vk6386WCUstof0deAsnWaofq7xtKj+hYradiQNaoWv6/asPUSi?=
 =?us-ascii?Q?RtLabcT80OG4Z7z4dM/dOjt6MfeMSwm+YJ2jflryMIVKkTqQA5aakFhGQWsL?=
 =?us-ascii?Q?QVdUGs85JsE1iw4las9L+TWMbRQHp5wd8O89YPZIsJgeFraNbdF+z9qGih0H?=
 =?us-ascii?Q?RirDIKNu8ZYb+S3RI1kR1WX8Sei6TRkfIXVvvqwCQTox9qUqWlBzt5XGuGa4?=
 =?us-ascii?Q?BZ5nl7p8Zd+eM/MS7UOtxJWLABcFmV+6cdTwNr9MwZdHK1YIHsGzqoMQKG0k?=
 =?us-ascii?Q?Wj4n5sFy7yiPkSPt3ktWMN6Yn2nZQ6FeOfCbW1qySNoUe1M74Mfvfz+p4xTS?=
 =?us-ascii?Q?CQ1bsfq40XQYzOppEEDN0Guh8D2GO1gPkrvtTnr+PLXdJSKXTu2X9yh2zaKv?=
 =?us-ascii?Q?Ju7HTdw4wnvO/0HSAiV4W4VsEVm2wjdctesXcRL0g3q6Cjw7jetCCbfcaikL?=
 =?us-ascii?Q?KGT1rEvn6qTYsVvL/zelczE7fgpVLMQWNEczENUMOCQcXyDtd1tPzL37WXYt?=
 =?us-ascii?Q?K5NhAKm2NCVUxVHEjQ26VynqNpT8c1Z6pzVQNyHcvvCKrd6YUgbYrswaiDqu?=
 =?us-ascii?Q?NCmzsJ8Y7FfSzekOoS3kiWhyWF2y6AY+Fupe0ggfgpk/PBKIKvY0vuDVG2Ew?=
 =?us-ascii?Q?2X0ZcpjuHauwPXJua1Lzj3EvizuY0wIpEz1y9KYcBY1273Om2gSkTftoqu9p?=
 =?us-ascii?Q?/qU0fKS+mm0whXGPNcGQ/io1wY9asQuQAEuuwnq5EyDYbMzmTb0ztI3CEKUp?=
 =?us-ascii?Q?Zp+M/2wDcjBVa9O76SCmrwdDiyWJ0H7ey85WukLLUzX4+6LmysFwg3ZcfetG?=
 =?us-ascii?Q?b/Tq6+HzlAdD5WBWPm1PECLWlH/w3JfzkBWtXXBy/iJObZo1aLp4FQdtu2rI?=
 =?us-ascii?Q?Czy7sJGzZUsogRc5AxiiUTTHPAk4XDskK+/uPriCmnypP/4VTj26SW5eYmuF?=
 =?us-ascii?Q?ZBC1bxFWYw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74555879-bc07-454c-a9ce-08df34da96a1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 10:02:34.5532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QR1E1FjOmTwszosi9P4cxttvpmLzTblJY33Y0RoLBQ2SxjtdY9npQr3wZnBRCKUWu5Nm8FgYPGK0ZLV8PxtrEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB743615
X-Stat-Signature: udxrh46g98tp9d5xp1biowm55x8yda47
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F384F4000D
X-Rspam-User: 
X-HE-Tag: 1793181759-841054
X-HE-Meta: U2FsdGVkX18eLSnMW3ErcuKwYo7bPKSnhMnNquGMI9PO11sNhokwjEe4gTGUc5ild/prZ9Y6nT34hpr+jIfeAwvRxfMwywXCWPYD4GihbPWWEQZmG3hr+Cakiq6jGEM32G/mHPVysJWwMMPVzDjISZ3147zPktRTJfcaokyiH5qXFC6PxjTzn41btmwSX/fF0qxKqD9ao2OFCHdv29INtbpGsw0eJsSYw7Boo1MKjsGaBxuVArN3BoYPkoSrfGxFXybxsrwXcWGUXMtATIivjcliHi/LQ64UbFYMXUQnNHeucOnMz8lfrT8erOPNy/rgPEY1PdANyYRF1+SOFCky5HeNrmcNSKbMDgtl/21JfhWlh2+kcrnbIXwYGWnxmGxZ7NCea2Y8kvQ+nVgZHl6wXrUVNrFhF7VHtaxhd8JYOVz4C7DNchq4QJyzUo2FIQFJguB9c5dNAmTzZfZckeFF4IvqFpvVzlDk2E7CO7S79dOnopeokqleCgh672CaYuT3nRmMkxfmZtVBN8qYm4dMTd+4T29kmyXt+QPsjntF7YQb4y96a4SBqc8v70WcJY675BFU1JP0CPTpoL7tu9sCI0MQvc/jm5kP6z0EaiMAEHDnsbCSfUv+vnLqAbY6M7aH/Sfn9YbFE7V2jfN/3hMM7f82HOEy8pUXQgaU/K+5QYS6vJdZ2FZlV2cpiVUEXFRmohHpW1LQuygL0UKnoYxsM1FuezDfNgoBsPqEFKgr50QGvtHNuWB5zSkRdYUCGAtCUh7LE3qzE2TOaj59UZEsKyDS/YVU8l1eWbDYUissz6sdvwniXFJBrMmdUo2yblsHvToZm+TfgasX+jFTuVW9IMAYwNRiYgEJrDNYi4FJolOEeLQfBtC3kFEN+o/xAIv0HlLuZwASg97o6B9BcAD1RT2uhOHPmyplUPbbREKmtalPk0sI5PvBk3qcGzVJC5vjpAKxeyyjtZGavIy18yl
 NCE1WnOX
 jrk4xQb2LBLbdDZGbw2wZ12U9pKxBMGHQVjuWimZu7UJ95GFqnCAw+THDRs3SDl5mh3cY21JBsU6pdh7bzWwcI1okkLsBlJlZzBa5gGEB8PBsDKN4Xn2xoSwiLraunbNlbAPX6C57NUAqfFASFh2cYBQd/kDB6qTbgHDcencFcagy1ZpWGHFFut7uiCwsGhX5YW3JmX4u7jh2spgJoKNFCkypstgfc5E0wpK0xYBBFJn7Kf6mjxgxai/kbF4ewILHVuPQ3rraz9WtZ5nxIlpsJv9HJ9LZeYrI/oVOhPQ51bc4Dzv/x/w5Df2RqqwwRpamWxvnU2wyZdZXQXlPBARWFEnacnRdg0yZ+6ymZNavCCLcSivlDT2pv/0ASUwAl5hPYrKwtKjJZhu8Ug1604eXxwKM5kQZ6fJF2uqwGMhaKaKQG7dgmQoSuuRm2EQ8nDvRlhMhBeWqJYv+JM7uZaYOiab7zddBFytiFpqRnY/7AIbs7y4zxlVjq1/MOrxSIAedZ8YRcWAk51jYEU3UXAqCF/81nTWoOPIjivJDVc2qP8RU0iaSqfmJDVfdKMRia3nVa0/6WO8qZ5xlgfQ7AbGsdWz7FsimLJp4zHliU4dsSdORJ+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:54:59AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Any local user can bypass memory.max with mbind() on a tmpfs file, and
> allocate unbounded kernel memory.
> 
> mbind() sets a NUMA memory policy for a range of a mapping. If the
> mapping is of a shmem and friends, the kernel also stores the policy on
> the inode, in a tree with one entry per range of the file.
> 
> Each mbind() on a single page of a mapping can add one shared policy node
> (struct sp_node) and one struct mempolicy to that tree. They outlive the
> mapping and stay around until the inode is destroyed. The tree is not
> bounded by the file size, so the file can be empty.
> 
> Memory that user space can allocate must be charged to a memory cgroup. A
> slab cache does that for all of its objects if it is created with
> SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
> structs without SLAB_ACCOUNT, so they are not charged to any cgroup.
> 
> Reproduced with mbind() on single pages of an empty tmpfs file, from a
> cgroup with memory.max=8M: the global OOM killer killed tasks owned by
> root, and the machine panicked.
> 
> Fix this by creating both caches with SLAB_ACCOUNT. This change implies
> that mbind() can now fail when running into memcg limits. Further,
> the policy_cache also serves task and VMA policies, so they are
> similarly accounted now.
> 
> Note that per-file limits are not really helpful, as the user could
> simply use many files; having limits per user is tricky as well.
> 
> Fix generated by an LLM and submitted by Chris Mason in private.
> 
> Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> [ david: smaller description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/mempolicy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 0884c629670d..4da1cb8777f6 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3372,11 +3372,11 @@ void __init numa_policy_init(void)
>  
>  	policy_cache = kmem_cache_create("numa_policy",
>  					 sizeof(struct mempolicy),
> -					 0, SLAB_PANIC, NULL);
> +					 0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
>  
>  	sn_cache = kmem_cache_create("shared_policy_node",
>  				     sizeof(struct sp_node),
> -				     0, SLAB_PANIC, NULL);
> +				     0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
>  
>  	for_each_node(nid) {
>  		preferred_node_policy[nid] = (struct mempolicy) {
>

You have many of them already, but anyway

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

