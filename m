Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB9DF483E5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D8B6B009F; Mon, 23 Mar 2026 15:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F9B6B00A1; Mon, 23 Mar 2026 15:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7836B00A2; Mon, 23 Mar 2026 15:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7DE36B009F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:08:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59B58BDAB4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:08:50 +0000 (UTC)
X-FDA: 84578264820.01.A82A76A
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8DE6FC0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:08:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vvz6Sz3M;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
	b=bfY/ZDzz0g3YEk4Fw4oR+ZRxWh4b17BKBvQKXb9W1UH0hjDbqHxbkYpTE8Z4AvOinrFFCs
	dSsDNeuUrWERGLgN5ok4zDbXrRrpQVMI9Kl/YDIMwydDXZIQdK8gUD7rsFYKuNnEFmGvBz
	2wYJLVUyBCnjided2f3be5K0CpNRlcc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vvz6Sz3M;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774292927; a=rsa-sha256;
	cv=pass;
	b=KKnv9IlmSZ/NvyjqWaZG5D0rx8Iq4DlYF8G1HcMqzOMJU/6USQKc2n/rZMIHIebGMwQGI7
	oYppGQ3VJmX+qX1On4LbpkvovB6j5mHVg4JtXF3v3Zb/8V3WkaQkkOj/bI5GLwQUL1niPq
	yBk/oq6bJEc6POh5PQpATO/CJhp0W8g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yt7yUuePZi975Knw3jCXWzJ4p19r62AGxGYlZYj3ZNvwRrW4K81RMILWtKV0pBcEo6d/vIyzkSjsFo97drB54pB9uKCjIJwcspzoyAofyylunuB3XG3fehHpcwi4tbQEfEiV1COimoBhVNLnTW/l0wXHt2g/I7Dr/okdUYOIVFNkb8HwKnp9N0/3Ru64oVhTZlhXk1bys9/07y3QfZMDgMCytTia5VfuwPfDCinOCq1X7bQrcAogq8kWNOk++A8rdDueE4R+OtUmFQEHgWIysmi/0kHHt4cfTBmO7l9cl/ttgZ0uBoLe6PbHoGZrtglbueFUeeXMVL3p4KW87gNcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
 b=tN+ffwmLAYYNiOqU89EJki+BggLqLStiXNUHFxRhpcPWztc+G71tXnhdf9OeSMBj1d7i8GDDwM+c+RtoF2G9qzBv6LHj20N6RLPvsf2Z9gw38NDERHlztmrjxmc/MbOedXNtBQ6C4kCwB2wpBLxIAVyW0GUtgih8J3zRxPl/4XOfjYDzm92rwoWfG4C+F5HxN27L8uxfZ0/9ZyG7000aggjXf6e+7ZEqnOetWFp4kfNnjNU9jFsvg1BERmb2hhwBvzrNQf6DEsuGAXPvEfREz7UqJjw6eQLkL/eZEsug2UZP+z+RnFAN5fUN+v9wRXSZ/0dC8UeTfVh/vVyg+TWLiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
 b=Vvz6Sz3MQdoz8Rmg4hcAQ/XPOOG/0A4FiSt+zpWYjiIwV7b8WLWl3arNXpPm7/sK2BOnOTP+yTOWPrzt824EWyqux1tMdxbd49vqti9PYi4MK5nOlDinz0eC8PhrsxPnDGFo0OUji1douXjwjjJq4JYXksIkKfwiNibri8LtOr/7nocveV0EEwSzX1ZOTgtBl/BbSrR1gXL42fckrjhZ937wqN+AVHHhX/WP02Da2mZnit3/3OctFXOIF9xY/EfYfu5wbKNQX7sC7mo6Lop2SFT7jZJMtN3aijbmq2+PjwmoCraGGWUqNNpmA04SBV00sV4ukSbuvR8W3bLNiRcvKA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:50 +0000
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
Subject: [RFC PATCH 01/11] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Mon, 23 Mar 2026 15:06:34 -0400
Message-ID: <20260323190644.1714379-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:208:329::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bced937-01a7-48f2-ee78-08de890f563c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mNX5bsjlQV20gxM+S+LJ+jgUE0d1Ym+GGujM+YBWTPv24IKitHjzmWTpRTBcSkeHHlzG3LKIw6LBrGiNcllMiXbo7Hg6oPbim9JrDro2dEOSjtTJeIU0LtMXJf+tstx4Fl8MvfTo5dsXg0f0Bu+Rv8vKStvH/o02a5kASb5erDvUiqTbKQqMvr5WONk1GDwLQOttSc+KFPCCIuQGvBeJH8PNeL/KC6QYSf5ZcwDJXQ/AKHY3K6vUS7c8jeFe6lXsfbCFs4K8IW3sd7G8aAdYoFuIK0nSGYfJmoFHG/w6YczjZMUWmSEDUShJWCqqcxb0Sq8jm9e2J/8+GnJIxQuL0mVFivaiFpc60mNipNTuEwQNycP1yMtDFVgDpM0ci/E5baMKgo5dQVx2NHwYiDdAbUDz1+pjXFv8J7bh/jghcW/F0y/ciM+UP5xf8HDMW3d2TDjoxstyiU/dOGJkp8TOPwc3oMSvS79RS7Krd8DFEuhRFUMb9bGHuo9T/Qpr+67aNwswzE4RxRXXod/Ywn0EFy2syr2Q/nsbquB30+7+bQSzq7WQHRteMfyVvulyuljorUR3GD4cLGW+SoE5eYp7MezefEQT1jUVl5YcBVmwNwlJTC5LjuLzersRBxV5SUoaZUEXdMFt+FgGtr3fz4GGfU8h9EiUvB9pW9L0ew6fYruFfrd+oJzaw015CQ830EA1w5tWi/ovfSNfSZ3/9WWwRaMNrp0/zlcUvB9Z9+LtJwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1G2L8E3bZ2u73mw78riuUfO9OUJNdxWJD+4Kk3+t+y9Z+fEUJtz+C3F52PJ2?=
 =?us-ascii?Q?5QuSK2c2KkFkhrtwiYmsCQcrj02QfMCaDE3r9a7NchUt+3DQ8PJ+ot/MyxF6?=
 =?us-ascii?Q?DWVW1450jgDfKw4vrCBXjgD3ItEamrIhmDo1ZKs3PJZV66m50Ap3Q3DvdCKM?=
 =?us-ascii?Q?oiEk41xd4oaBuu8EQEoqDUUlUTgg6NWQVk5pRd851y4moJqQ5zcjWXdzq3bC?=
 =?us-ascii?Q?dPmC9m36HrsWour+bQ3yIg9FOpmHt9PwB/d6SRK6kvAs9G4xQX4TbSo7f8j2?=
 =?us-ascii?Q?1buU7KvC/8Zp9fvdPDSmI5X/eISwDEpZhf7T/FgdEoQz0ggOfrtBcgWJ6VRw?=
 =?us-ascii?Q?vJPKvHcUZ1m+zXKxT2uwnV2VDVdaK7XfLdFsEhxytr/0VmYf53XM842Dnjdt?=
 =?us-ascii?Q?y334/zKmBaVYo9v6IbYzSVVv3KPJBXFsVByFkdLAaTbapBrUTHV/ocuNbi8o?=
 =?us-ascii?Q?1HRoQDrDq72Uq4IQu7xg9+uvli1qrTXeCb1q5O3U2ACBWRuVjvQlYH2Eg2n4?=
 =?us-ascii?Q?s0PdHSdm1kYCUWptkwC249g2UR2rQ+M6zo3K7iH0suoNzR6NI+BQRIEvvB8I?=
 =?us-ascii?Q?FGll/VjvS4WTpaIRd9Vg5to8MCayzzZEzNCznQzocdJHPln3E6oBtQfWrMwo?=
 =?us-ascii?Q?T7KIxOLVmM+oVKWyOa+LAS3jU01ysJgqOOhKadLlVBEquqZafn3GlN2mlSlx?=
 =?us-ascii?Q?BL4dMtLJCRYDPSolZFDxT2yhqoRpvImrWbwDjp8n9RXTQGGNyIsB7KU+gEjY?=
 =?us-ascii?Q?5jwe8Tgd5K48QUIYI51WES83D6hUT/VmmttdG8ezdyT68DLdqtBaPf7JFrmU?=
 =?us-ascii?Q?ivX0c85b3AXxPkU0P23zUleEGxELN5WDRa8U5aLmVCSfpRj45mw9i8OqhEMh?=
 =?us-ascii?Q?chf7PEasyNjdA7dbnQGX08CtHyzXLFEXZ8iQceOKfqyQIXy4XJ5w6Eq74sWp?=
 =?us-ascii?Q?rhpDkuvuZvPaGaHoB4hDVJ39v8toxSzisXIsveesoJxCXdk/Xyqp6qEuRhkN?=
 =?us-ascii?Q?iA6WmyyOcHsvfJSpM4zxtMvPqvhkMkZLwg598rikq2l4uBeWP3JfxsCc1QbB?=
 =?us-ascii?Q?YtaQafwRAn3dkudpWsE56/H1G1JQ4/3NhDHCONgf737Vbbzx7kAnjmrGVIWt?=
 =?us-ascii?Q?gcNsFH0M3tKWJMhLfy/N5JcV2gfSt0ln/KRgpGm8hmJ+Fj0zgh/2jr5Ku3By?=
 =?us-ascii?Q?0RAhpXHZBHGBWceiWpv/ah87yfiFmFyOSwNZbwNi8CsSJxBJpEGUwANBux0e?=
 =?us-ascii?Q?elTfOrUIgPE2mK/adZAIECe9OyGOscKGOOnBlUpRw3vCOhUUk10fG9anZdbu?=
 =?us-ascii?Q?+2jXVkHUKmJhkUBvCtyybKg7V7Wm4DwuJjSmY6BDbmRtUkxkq/6E63U/9W5n?=
 =?us-ascii?Q?c5QgaCWMhUrqQbT3E0CDVldotIXUnbdUDT9bq43gkULpqlj5XXb7sz5VP24s?=
 =?us-ascii?Q?ZPizTj4hETw0YuB+UH53TIRE5y5WoOQeHpAAIYtdU7XdATs8BCOdXGNlbigA?=
 =?us-ascii?Q?1bD0e0SSgE1SttfLMxXMhMuyw1QIQ1dQcqUtF3AChqp/fAFqpg38nZO0EGfM?=
 =?us-ascii?Q?R3RNedrwzSPDj3CBj3iwSxj837zSO4Bkg++efOgeyrvzUTZts+avUPhDfwpZ?=
 =?us-ascii?Q?BORcdjKeQZZYCxY5ZS366MIx4fZZa8UM/cYujfrN/iiqsQHWPCRrhklZezKi?=
 =?us-ascii?Q?3EW6t9agme+Kqo+qb8drPr479EDN4fxFtV4nFkfzchN8ERfm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bced937-01a7-48f2-ee78-08de890f563c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:49.9293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt0JKUyPrZY9yv3QdGxAQgBss4rXAYcB5gOIfpDeP2Cpr9QP3vib10L0u5E3QNo0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813
X-Rspam-User: 
X-Stat-Signature: 4w7shnok39176pk7s6hs1ny1xzzp6xk1
X-Rspamd-Queue-Id: 8DE6FC0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774292927-656004
X-HE-Meta: U2FsdGVkX18YhIISqRE47MLnRyyCSDFbyLupbfwFUz780Jrpkz0tMYYdoz6+O/1y8eTpcBCR0Ob6XPuRrPxRbk76k1yidJOgXCs5OeGX8rmVchD1NcR2WsHKbsviZKTXUeRt4y1TeRZohC7wdp+52e7sducfzXrRl/BVxBsT5O4vl3QcEdGp6vWEwnNXsQwBdQiVPQNOuFe41u9s2u1kGZXmE3HlLplWy5c8is5V3QnukvjAVyr9pfrOHQESEwOUtyTvNA+XaQzdOe2xG/SZ18x4O+SO1gcgkr6sn6G/Zwh8uaxS6Zdux0Z01+mptmwKbvuyYpX3S3tZq97X1TqKLTLbn7FN6BV0Nlz+kA+5tQlFEsbulX8EkSJ5VPdDe9suxkeGKKDWSoe71ICX/RWLPWoGwr8wuUi1Jg+BzAyod2c+hStGcdmRr1nNlz1ZFGJAOzZMqGVoRxoPNuP91qteS3ye3f/LWjVtlEQR2U/FJH/mOsmE+GhuuLX2YcrLlqvmGOFvCtcqCM54yidKc6SpWMuPZHlQSlZFva4Fef258ZSApZMd8235+Eah2Dzo7SLbrmII8QvYfuHcuHMZREKzFUIbACe5pDNPnuzuYSh5kMW0rh5xjPDrJxONLluzUXCiz2Bjs8Dn1DqmBOBoSgpaDBc9lw05JOLMLIiI5dl0O26pmJjVYMZlmb2Hlu0D+9koL9MHknGN0QxtYJgAPpcL07rsNan8cGE0hDKBJMHQUduFWRayTOfIc2btQmenKIDHW8wTdZWEXGZMlFVjNUov8QK3Z+BGWqPpRdvp68mMkwTPML7ZjTxm8/W4GmvVVNA4CeNNMAbD9+KxGc7EQvGe3gLtHu+Si/zUc3ibn3nUAs+24FwmSfPCFC8piEgOa6yrwancb0pwWmWhvyvoiZcFELXv2b0CyavTHaIqn1Pmt827clYsAZh1/Jn6MKuN31NI5A1Gn0GQn1ADE+/ZYZr
 YlBke6FR
 FGY9gF+LmJ8izAdGen51Q18pnrjWnB+9y66uBilKgx/iYvF/ymF07osAN3acnx6g6NV2yCdBMHjxHUTvOGFiJ+su3AtCdY4tckxZflr5Vnuipgd01h8Eu5fW8eBRS8U1qb2SFPBruasv7rhzFuV+SnG5xil5UxdpGukDTh30vvvs8zggjx4nQrj03BYj69HWGlly131xnNA/NqP3zKp4soBL8Pp50k5MdUxZMj2VrxfxPcOIC5jH+j5qzUX2dliNjj3ZsgsHyYWxskTFNCFBUZto8tGqM18+Vt6yCAepiunlR3Y040syggPgFUCoRFVQ+MWL0IGTYw51u9a8SLwCgbPxSwdSiR2js0ntA8qLcpvFr9mmAvmx9RkHzWcqns8vmNaewW9EcmJQlnZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No one will be able to use it, so the related code can be removed in the
coming commits.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..408fc7b82233 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -937,17 +937,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0


