Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16825ECD6F7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E8C6B0005; Wed, 11 Feb 2026 21:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC736B0089; Wed, 11 Feb 2026 21:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE236B008A; Wed, 11 Feb 2026 21:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0C56B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:01:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BB4AC2677
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:01:14 +0000 (UTC)
X-FDA: 84434152068.27.201041C
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012070.outbound.protection.outlook.com [52.101.48.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94A0C14000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:01:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jrrfL5Sf;
	spf=pass (imf09.hostedemail.com: domain of apopple@nvidia.com designates 52.101.48.70 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770861671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PFWVBIgSAL3/IiPRbnwyJ4Lbc7BDawyxkkXEkT5TXw=;
	b=mhBU0fIOWhpaJ5ll9SZlf2Muvkmys5couF40MDOdlipeI9lkjILMGpAB98HD55Kf8fmSz+
	KE2f6S3oHC6YIouuX/X7YPnlK7wDCsOcHzkCHMxmkCRTLunF5aC9iWA3GAmEItoESG5pJh
	BzTxpyh2F19WXUUauWe+Tsq4Ogft9V4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jrrfL5Sf;
	spf=pass (imf09.hostedemail.com: domain of apopple@nvidia.com designates 52.101.48.70 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770861671; a=rsa-sha256;
	cv=pass;
	b=uweEDUr8xfPvX4597lS00QpXUImfO9EW0itZ13hTzPTu5hljS5ktpVKGDTsZ0qGBuRgtRC
	/9pbti0l/SwiDFILrHW8kM6ZO+cBg8nSpGHz0eA9x9VYTnGkm7mPVdgiWyAoGhP3VLYjYZ
	MexVT02WUWDA4Fnodn+M6ka+27loMSs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LURl33DhUnk5nzWllSwnmyKpMoivRb1G/Ov1pngg7ITgbGrNNfwRs/Tt3K4cras2kD4J3pFDLXwEC/o8B6PIm4MU3h7yiJK5AcnP6jOqD6ZPZqSFXzuDssFU1WZAW+hwgIz+M9uF/gpfhe3FKeO+UEfW1onme9i91FTxrURfmXsHDgkAQNsTItimdOUaQU4kDd6OxPNtZo8RsSlu7K4w+HTmq/9LhacoT3JalyxDK49wCdRfPxtIPZXQlSIc73OXI4w4cQZgy5QyIXYkRc0H0yDUD0520j3whCfCMgC6i7arNL+9Hfk5fbCUWShWdidZK1zZl3P0uwzj8ARWbTkovw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PFWVBIgSAL3/IiPRbnwyJ4Lbc7BDawyxkkXEkT5TXw=;
 b=gcEYsDH+esH4OOG58b5s3AqKvi0yhfxcfJWHobADP/TQnfK8cDBTJbhAnonk3D+W681AcC2Eqo/K+LwJgZJl932vg+/1jK5D8bbE+r2ZFmStNxm+ocTwgXhLuC5JEm7RU/vK0798awZyYC4ig+r6NRavrJ+GYm3dMgCvQYl3rdsdoQRwIUoPJs8640zgvwpxKXCJnQpQID/XtclafjXuhLnUsG2rdDyCqdvVc0LofPf8EUEbRfZEgBLqtZmwxR3QtKex443orj4unYHwF3/ziWVEEw3Zexw2VH3668w55T/tCeAO91/UFGs1Ek/scQ7St0GzHBqyF/Pdh3AmwRazAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PFWVBIgSAL3/IiPRbnwyJ4Lbc7BDawyxkkXEkT5TXw=;
 b=jrrfL5SfDf1FA+3hhA83qTH4VRrA1o2F2GTmAzKy19MLVY6HYbtbUqFxdxe9TXHda5Wzsed9AU+5/7VACuml8AhswTQy654V4AdRyxCWbE9QUFffwpjUAU3F8PuSaIjEIFAbsuxjbc35m81onNw2dYCrOXI+uDqQz/eLHUzX7W5XZeyIqxh/mygDBEOkEF1t02PcbsXNIM3lIbrLndPX+TOZwYCqYm4iZyEBMQLYzGKgRhmODBOdM5MmrGD7fxBIlSGBRlfl0oRjXpn7RbaIHPx7ENHPeVEOJeEj+ey5eWb47fUTiK3AsPni9ILoGdwuf2hXywJHXqIorUDDe6r/Ow==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB6341.namprd12.prod.outlook.com (2603:10b6:208:3c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 12 Feb
 2026 02:01:03 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 02:01:03 +0000
Date: Thu, 12 Feb 2026 13:00:58 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, balbirs@nvidia.com, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, jhubbard@nvidia.com, jgg@ziepe.ca, linux-mm@kvack.org
Subject: Re: [PATCH] mm/migrate_device: remove dead migration entry check in
 migrate_vma_collect_huge_pmd()
Message-ID: <k3v2ldtu36n3udzziadwxbyj3tsrqwtrwardx3zw6nuuewcozf@wquljsyxdy3b>
References: <20260212014611.416695-1-dave@stgolabs.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212014611.416695-1-dave@stgolabs.net>
X-ClientProxiedBy: SY5PR01CA0085.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::12) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c4426c-9764-403b-ed6e-08de69da938d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bhDu3S5Gaw3ZW3/Rmij9hjZIYCdcnEq/f1+wOXLPCd5fTHfnNqghQUM5Zn/u?=
 =?us-ascii?Q?w3/Fa+yWpOq++kxVtl1goiiqhd/SxN5sJw33jhmc4M0jREO2S33fS9ZG9qA4?=
 =?us-ascii?Q?DTiwjbsicD/szjh6BtlcjhCH3vqDNDGhQzXDlWSfZSBRje7IPHwCEzpc9m6l?=
 =?us-ascii?Q?kxtgfMq8NUeIRgsQxr211im4kqQnENnl00XXUi5zvLOyjzFLHUd49ISeRb9H?=
 =?us-ascii?Q?LXBhGda3KNkJ0ppL1tD/VoVWX7vg3h7zJJ8+gkDhtyZn86bFYCuUe1jYw/bj?=
 =?us-ascii?Q?3xfbFsJDsb/VhOak1ajjQoBArE5x4CQKvMiws0qAdoK6qtcHztv3pn+d9Mzc?=
 =?us-ascii?Q?8Dn7r1M8MC59A3eIes50/cFJq0qAooCMnG1IIQpluhGzNZj8gRSh9vTUIYCe?=
 =?us-ascii?Q?48aoxZLaSMHvuHaTXxdaL3rk/9S9J7Q3PgnKVe4jddwe9haomV/aa/oWJ09d?=
 =?us-ascii?Q?6WpCJg+kFvpkCe4lgOnvjmEpqIsE0VxHLD8aVWYo1+UIeT6PzE6xfibKgXiS?=
 =?us-ascii?Q?LZUbhnIR2p6o8abXAN3YVIkXxG3rMQPtr9vmgmh8D2AqMefgIh271mEjBufI?=
 =?us-ascii?Q?pcWEplsQ+1inWQ7/AFTIf1eygZLxhxTEzrJeAqCjwZmzaSJ9I+M9BrgeHc5N?=
 =?us-ascii?Q?FMJyugPQP9NDEAxeF+NW8xbeSoakmpOHtgCP0aZRtRHGjCVtM5EZ6RApsA4S?=
 =?us-ascii?Q?qIciznk2InpJZFcg4dByBbVkWtpZ7R/qrkNtJB2wSWbOTwLtbY2lyhSMAYpu?=
 =?us-ascii?Q?Wl8fqN8EigNcd/09dbxKlOtNHjBIMd6lrM3+nkUMmLeKV/T4c5EwB/yiP0Zb?=
 =?us-ascii?Q?JFDI3K9dIz9zvlqxmK5A4uSt8JIK+4BL++5xmja+RU+kZxAE+lWz6K0W7Itw?=
 =?us-ascii?Q?OK4j2OIHwgggnqAzFkrf+btutCJh+jU5vKVv3qM1BUW33ynly9JY7ToBzv1Q?=
 =?us-ascii?Q?tE5slvc7rfFBHzOB8Bw3Hs48vV9MTHO+VmXzSisRGCgGI42nHWoHx6B45wWF?=
 =?us-ascii?Q?W/ntuBLhmRj26mHbFqjVjxP1Ohq+yS6oSw8MGSQX2btPJVwU0aDJwj6+aK3x?=
 =?us-ascii?Q?nLEiKtcO7IVhjX25TFfD6O+D9vv4RWm4JKhBtzBDuuGGHAXoQ4J2QYBzJpyC?=
 =?us-ascii?Q?CBgDI1F7su2qE3YC3yWY45ZHDO5STcI1nEeFuII/FZQSh0AwGazw++iuKeIN?=
 =?us-ascii?Q?maakIa2UA5IAHRgKhs1gpAstTUIt3l7Ez07TZEodXFeou+v7ERoaod8+Y7De?=
 =?us-ascii?Q?alrRbwKJPze8Y1Ja6IbHd5rqu7l4FH4uPQjdBlboL9/ktphsSK4hOkgCFI2X?=
 =?us-ascii?Q?w/7Log3whs6l5np4Ze0wozjF8Hct+mHJlJYP90P7vynS215PkMu0E3hWmVzH?=
 =?us-ascii?Q?muwZG2VuUJGX/ZHJs3xko202zKWij8BJk425eEBFvcpnrshvJ4Xx2wq5jRz0?=
 =?us-ascii?Q?3sEX0LjfsZ6QffCd+7f0QzRH5KflA0kH+EN02jYlnCxffXieD1uCmaRb5iuU?=
 =?us-ascii?Q?Mgx1ZYr/yDbxFy1OlOo55M6jauG/zkx0FqQKX51k1AlIKmoTzZuL1tkM0owb?=
 =?us-ascii?Q?PfN+eqHwiGQUSvg3Hbc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?617wvEc7JsOqWMVDv4Sr8ORHegQfS0lq4e7JpdKspbJx5FvB52Cm/cCQmyva?=
 =?us-ascii?Q?HFH8XhqTRrkIdrutc1NYlp3lkdZHIh2hPDc+emubij7uaPbA58gBBr4y+WIa?=
 =?us-ascii?Q?LGVKx+bRgVfVJOZb+XIOM7TfStUH0WvR+VVKBW1T5Jl/GcHTyOB1HZdWw8Vd?=
 =?us-ascii?Q?a7InXctVIC8xjrkrZVt/TwIeDObD0B0Tw49xjLnnU8QzaRriKDVFSPvLnlyc?=
 =?us-ascii?Q?ZAY/o0QJfcD7M4PLfyIkR1cQStmGzAQ3w8t7qICNj7jqa+1bEqf8uWwzVszS?=
 =?us-ascii?Q?MzAHhslsOMhtFanyha88hj9qoyydQdGZ6bJ2YUKXeeEGRuViRTCyuciNxbCn?=
 =?us-ascii?Q?5XtPleVdoAVC8Bw+mZgoH05tHJdulnm4f9nnzAk1PZ3qttOXj4+raDneoL4d?=
 =?us-ascii?Q?AMcCBRcZPqbWfbXCki0G+eChQEof6LWrJNQj00ltr6auzUANqkNVa0zuShYy?=
 =?us-ascii?Q?aq2DAYQesUyGAfEFgOpcUh1XbyiDymV4eEIKYnJEgNPSooH8KZoSBv4dNhUl?=
 =?us-ascii?Q?nwmGCLwRM2PVcJEAmOb19GlfkeKw4oEID5zBXWxL/159s3PfAajTFfRUkOQ5?=
 =?us-ascii?Q?DQFMvD+wpDnlVsPgPdP/biJ05gA3Fu0ZuUeqBAAgKSvVAA8xxc2iA6rhdLeq?=
 =?us-ascii?Q?ohPpAbmN+NFDFc090DVtBmTZh61UJql+uS9bq4HQL3jK8mxSs3Ms1YpO75aB?=
 =?us-ascii?Q?REFFqLZSnZFkCBT7NLIhixFCkYUtA+vQeK+SlMI9PC8QnrQ0KehZuLcTIvyg?=
 =?us-ascii?Q?cy/BXEEYI1cEZ6IP5WhVnF0+8nfE1BV74Yk4CZhwo2KlG4oN6HXxJ0AiU0+7?=
 =?us-ascii?Q?aNFGp33UX4oXrvuPCPRjWkJB4JFVW/uX5fCnSo32xIFctx0fTkQINjNYKeT+?=
 =?us-ascii?Q?XqVU+Hfw2dX9pgvctgxUyi/t+HfZmfsneU1x17+ak+SWGqMaSfwprICr+NiC?=
 =?us-ascii?Q?F8jWTgyeoSZdYSt+aCfz2eAESu34PCZFejnembYT8MxyT8W509gni3BO09eN?=
 =?us-ascii?Q?H9/i6ClViLYaaeboDuDB5zSxAzFcyLOdbL3l5PV+V/cnwRqD84BzxU/uS8Vr?=
 =?us-ascii?Q?R+ZX4pcKbfw6PPC+e9iwV2KsB/v3bVG/cbwYP97zXvfcouvoV7OaQem0NuXx?=
 =?us-ascii?Q?WCDyChHoam3ILVaAJtuV7HzI35lHF7+bxA2r4h++wQTKNm6VCdR+AVzjbX0N?=
 =?us-ascii?Q?eb38vxysC4FYZWza/mEzCS9lSDd1we91kTpX0TrQxp6D5303itOk22ocZLtV?=
 =?us-ascii?Q?2tdGZA4TpwnwThp1olHkUU4dAi44np2Z7kdyNB8aJ2mLOKfXo963CL/IUlJW?=
 =?us-ascii?Q?tnqmXZXOJiIojOJFhugURLpfXeCvKNZzJQR1q7doJPAiKuWQ26hwivz93Y/S?=
 =?us-ascii?Q?p/GM6RitaxWdBKOpj6gE/iY7dJY1iXfLGyU6HloSYpETDoygzP1aH7+h+BQG?=
 =?us-ascii?Q?8d9PbvxnH2Zj0t25OY+bPaI75J3UkGt5zV+p03bFdbHGiSbpzmtJy9PNy5Ge?=
 =?us-ascii?Q?KSURfDjj0X/acX5GLduA5dRUwhndWuTqo3GYt6EBjbsJDEwp3A6Jw7fGH25z?=
 =?us-ascii?Q?VztMXBwxLzDYMk5kGMErCCeEMJfN/Sn/5Jv4bWvoznIgcfDrvP0a1XwQsPt2?=
 =?us-ascii?Q?ZMBgipsZiKgMOP/Ty43X/RC2Uc+MG8v5J7eueILDRRIiexL7zytCyuN+oDB3?=
 =?us-ascii?Q?0pQZSm4/Cx17CGCPa9+4DDwbhw1BxUldn6y8m3rcf1f7suOvf/abcRvutywi?=
 =?us-ascii?Q?0pYKr8odeQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c4426c-9764-403b-ed6e-08de69da938d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 02:01:03.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: St0LGtwvQeXLcm4gi2QpkVlXFjwwzFTtwxQasWhLG5TArGA+Z+E6MvF2Pv72xhJlwYI+APZDIncjE4q8esT/Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6341
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94A0C14000C
X-Stat-Signature: hw5pkziq4rs5obqr3ojz3ijcpnq15qoh
X-Rspam-User: 
X-HE-Tag: 1770861671-394699
X-HE-Meta: U2FsdGVkX1/0A71QDwXomV81rHN/QxIExA6Ub6jl1LitMfKz/S5QnPU9AVoLnmtDL8cig6bX2hbweTrgEj4z0ZnEZq7LOhcQUT2IWETG6KS1zSAc4ayRuhVcQ0rFek5LBeK/Ga2DqQVL1p8cOwbhWkp6ns3H2k0N5OLnUSkmrnm78o6vYbTSS6Jpo17y4qON6wj5rP8yNca9+TzByVqCl+G7c5wGPc0T+CdgKBPcHH6HK0KdhO1Ydw7AhIYnXx9c79JXZ8HtKk4n2appEgEfebxnpoNrDdNYZL4u0XQUO3/BgeyPzG7+OjR+mDhqyXFbMv9YCvCqJQFmWUHqTjjyAhJ0upUWNwTySj+6CmwaDvuNO7zMtYgbxIbcd/g6qPe2oL4Lo5fhsUF4OLpruJVttbphFcMhCosFvyB3KBrllJEDriFSZdblOcW6LD/lu3tsHQzUfnWqFdTetOHaGkzPDY84fGX0mWiUgEXROfmtAi6dsOb7Rn4Hbz2UymVpfvq5eeTP36LABiD3fUvQfqZCkG6PCg/UCg8C/nMXtiXmO8ztl7rGhxs8TLP/qAAh1osU2p/YYH2n3Vsbo3luGCkZCqK7uxTnuFQvw9VYlFR3fHUBLAYPEf2ZwGUHChIqIfGQVyr4MAuDg2D16R13A2oPo0bkamnZRB0yN+oy6bFtcu1daU9PKGm8J/2ylhQFtOfr4P2Biifmelo4mtAnzM8WMKmclh6oEnhiYcmAOEC+rsByBjIkKaNxAaq2Jz633mRQOtPjSL69md6Nut8zl5X/hK7kWdsnrzdJps7BGVscMyJF0X+ji+AwDsagIdwA637k8YKx0tRjfMmPgHD62HGOLAB04wyWry4vo3jWg2vIy4hjHYuvpENtKF4irt80NTeGIJhxZV+OBcWgqpS73P5CvCHWgnwTKKUoSdSHABLnGX0Eqd2OPIe8x9HDzVVUqBDxKR0owY9yTJZ2VcmLm/j
 7TB3C2yV
 7uW/ZvBGrSWmddxhGUWEp13AUMkG+iOttAajFqQBedPwdRF2+7deWv03HTc0SxqlyFs/HblyjtsD3UjglqiwgtvgR6fieGpDulLHVhUHgp6m/1+E1f0Gkr6mMRVimI4055j6QWdAV8tQGY+CdBHgxOYOXQYdDcv6BR2+bbLYtfW9wKvZfxa1+1Aq9sP0QoUYGpL1aCBxxAxfTY96s/TBoD2z76yoO7pKiqA57vGm1jE9bQBQILxyq9aE1FKXPG0PM5TmYqbhTQkoQQJB6Om+/snGeAmRgBhdcS1yGnUGPObnNRt+orfl7moLglvUEIRxgqs+GRroJ+OdQ72Llk+THDuwwyOEF9+IOxfhLBFNhVaJnMN3Y5Woyro+sGPe/qWiM24BBIS3i4dOvK4dryKvD5Um/oydkP1E7WufukO7j3XKd/I8fVt/IdjAD+IE5I2VJ5HY+d6B0lNERB5mMfJxlHqNmAJ9jBi+ExuSx65VwDK++GbZb3hJIVgauEuua54M2qSho6yQaKIRBO2w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-12 at 12:46 +1100, Davidlohr Bueso <dave@stgolabs.net> wrote...
> The softleaf_is_migration() check is unreachable as entries that are not
> device_private are filtered out. Similarly, the PTE-level equivalent in
> migrate_vma_collect_pmd() skips migration entries.
> 
> This dead branch also contained a double spin_unlock(ptl) bug.

Heh. You beat me by 10 minutes :-) I was just checking to see if the fix had
already been sent before pressing send on mine.

You probably want to add:

Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")

But other than that this looks good so:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> Suggested-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> ---
>  mm/migrate_device.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index c2855235fd9a..b40c1d49677d 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -175,13 +175,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  			return migrate_vma_collect_skip(start, end, walk);
>  		}
>  
> -		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait_on_locked(entry, ptl);
> -			spin_unlock(ptl);
> -			return -EAGAIN;
> -		}
> -
>  		if (softleaf_is_device_private_write(entry))
>  			write = MIGRATE_PFN_WRITE;
>  	} else {
> --
> 2.39.5
> 
> 

