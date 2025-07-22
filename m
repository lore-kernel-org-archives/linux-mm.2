Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB955C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859EE8E0007; Tue, 22 Jul 2025 13:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8322E8E0001; Tue, 22 Jul 2025 13:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726DC8E0007; Tue, 22 Jul 2025 13:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 633B38E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:42:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E7B01A04CD
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:42:56 +0000 (UTC)
X-FDA: 83692621152.27.2A8BF7A
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BEF91C000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:42:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LqW0ENbv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.76 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753206173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NllU4BmxovW1+vZrhd4CzJVJqZHr9398Ci1RK1d8H/4=;
	b=YCmJjo+1Ve+/jkjiIub8Kc9/PxhKBLJNJz0xoFa6nsMRmUog+cDOyphan6f7/PBk/rFyoy
	DAcDcC4AnYk9rL1UCTqtYh2e/05UDP24HCl9wPDqiL5liQu5xTSyT2UEaHCG6N+12LvO/Z
	XRszaOj7jrRqBNILX3cM2zVXX35hTzw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753206173; a=rsa-sha256;
	cv=pass;
	b=h2z2yx2l2VfcAaf0lKrJkiX+pDRaF2tNAmcBj+csZSBR5IwttgpEuLN4yhI3MgS6cjnr0B
	Na4y/dCyNTBaTNrbjaMFNxaDF2AouiRy8jTHbh413j9i14ip1LoGacbFJ87cxiMPDfgdq+
	G6vGpp3CP53xKCH/xfQGH6hhpt261/8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LqW0ENbv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.76 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uK0szno05SIul0nIR9tvKdLilUm9kJlgVa6VtkRNyokeaB+czaE6/pKKhQ+yp4pDu+lMJFQB4cg9IKAxLSeifz6bd0ipWbcMMkhRw2wfu0qNhkjXtxlkDj0CvtyXR6T9ogKOfqgBF8N3iecmtkVwMyQH0f4Ho+7uAhANpPWdWpnvL82tmi/L0Mqj26uguNwZgsZVdiS9A57MV0QuDNuCqfW5yevNmCTOSaU/mfUaHbR/gCTQmSrnCy+zUnBt4wSC5INwQk9mV16XhHbnPxFjptY2cP3NLSQEtexAycTUAlQYpPbnEgaT36/c1FeVyBFzd8AHfRzwaGMjft4ecrhYkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NllU4BmxovW1+vZrhd4CzJVJqZHr9398Ci1RK1d8H/4=;
 b=oieX4z2yuFzlcMTms7LaXsH3P0ERMBTsABeK8CvDUjhbVafG/ZGwnPlxCqnZuRbNtm0d4jGOIKCyhwwp3WfGzfwrKMgDE0eDClbRKLpL+2tVAv8LQH9zCsauqAy+0T+QZSEhtECqLtmeaU5y/RxgtBE6tRIPwdvdaA8QoM4SUJN2W6wjTtSj0IVTcw/7mQ0RIvMqJ3f9CYlsTtutCj3cduZ+z3XbNlgP/E0ifVZP+PeU8+yU6YcfuwWUy4mwH8zjvnI+9I13Yj9bv1f92lQImGMv3rSn2yWr4Bwx2Tp5Uasl1ARPs4fYjclUA0N2C9rKjJVJmYKpBsZv8b60eISXbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NllU4BmxovW1+vZrhd4CzJVJqZHr9398Ci1RK1d8H/4=;
 b=LqW0ENbvmNfLDDSyNZOxe1gg4jh1ReBN9akWR41a/ctVauGJ3VBgiOxVCDSd7ANONofp1Z2Wdv5dVkoU3KJTv249ggw6jEA0D8/H3lZ0RDLAhpUauYB9mKLxpJDbafNfQLkgEVvDYcQNkt8p0nbELnv+lnQOKEldCoC+SiICoQdzVuUqOzKd6CGvw9iJxGt5/rEKmgzFWtBPwL853+m7xM2yIsD/eDuAZs67U2f+9AwH2UGiVF4TlYLb/X3B6ZpSjRlk3h3QXjUEtCs0H6dkJ5ZgBagsgfNHfn7IO2HxqJoAvKnIS5SVXPglBVeyRyIe24qkI6cLOz6QdNHBpRTmLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB7782.namprd12.prod.outlook.com (2603:10b6:806:31c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 17:42:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 17:42:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] MAINTAINERS: add missing files to page alloc section
Date: Tue, 22 Jul 2025 13:42:46 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <F551AD99-F191-453D-8115-F37E0A74EE65@nvidia.com>
In-Reply-To: <20250722174143.147143-1-lorenzo.stoakes@oracle.com>
References: <20250722174143.147143-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0084.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f1da59-814f-4cfd-d5e2-08ddc9472d77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VJotzgJO3fLkD5k2DsOp7t/8YoGN3fG0j7NA/esEopDMhsX40IQ8pAn9Fq9M?=
 =?us-ascii?Q?qECgH4IsW+olmJcPx/MrgwQq96uU6BCEbWiMytD3K41ebqzrfnRa5NgygwTU?=
 =?us-ascii?Q?irRKFbOQT7EKs/TDo1YyHk+iFk6SYqH36x2B1kaRKKrUInHr89RhM0L8DZPx?=
 =?us-ascii?Q?mhyxvNwU+rumz+xRsH2VXBg876Dyd6VextEP0FMHnZOcgaKoo8h6fuz6DsoJ?=
 =?us-ascii?Q?GlTSTFc+YBDyseOqlYuthORuc/S+jhIp5ltTXJq9YMiUBgdde9CCZv196cj2?=
 =?us-ascii?Q?jB5xMXjLfBFKLru6kyAHykAlnRQxTCYCRWNwowV+k1Tdjq6lVxo6TkzWlKuF?=
 =?us-ascii?Q?E5i4N35kgCBXXLReK55oJS6yM7dHaHo5TzVyEXXm+iR6VKT5pRaRlle4+7Kq?=
 =?us-ascii?Q?TAv2VUY+toHRzyFEp+sqAQJx72hzlxF0Nci8dbs70SMU458NV1BHOhg5M/Zn?=
 =?us-ascii?Q?g9H6gsH8Js73iDBpSjEviTDaiGEhJgXQhfvNa0Bi3nd0UIrEbK8q/0/LObsr?=
 =?us-ascii?Q?ZKB3gPv/AxU9v69ld8sEmRHbuQm2DQ3MQDE9ptwGNcR6xU2luYtMs8I68X58?=
 =?us-ascii?Q?H1HE2vaSyM9yA+nG2qOpuh0p4RDibcT/kJDTmjRgbBClSWjN3aYfUb4dz4v6?=
 =?us-ascii?Q?Z/ZrcXsRcxz2j/N7IEcYS9iHEak32A6aGoJgbmyTAZhDr6CO8yc55r06YPeG?=
 =?us-ascii?Q?hCp3wPDUAF5Ka8YzaFDSKcvIjS+TnypCOXEVrtKc5PfFdARb7Vy2siRbygvV?=
 =?us-ascii?Q?BHh6MFEwcL7jdjnMdzLt9Ibd5fuMJa3Zao9Ly/SpAReSm1VZst/uC7oyy3p+?=
 =?us-ascii?Q?4LvUQFE07vqKKkPLQFPm+fpcDKlAYOKLp5EaxT7A6tEAESbuQfDGGCwMJpOS?=
 =?us-ascii?Q?Vw1NP0o562ou6SEHVGxlSN6IuGKp1f19gnI3nIJChiIRxJfdJhHDwAX85MkI?=
 =?us-ascii?Q?9bU45jz9yLcSsj1zkTzJi3yesLP7ArBvhX5Gz76+O7njJ7c097+3d2yF8/kV?=
 =?us-ascii?Q?MF6Wgix0DXOOhz8dC41RQcXw0Uqoqvt7B7K/uRxICqJhQlW5ALqQ/J1l9YnP?=
 =?us-ascii?Q?ma05bXTfibhdfIdwMXEtdp4qtwUhVWkR1bN/uD8/IWFIDqeiowwjy1xs2bso?=
 =?us-ascii?Q?HUntGpxjHTp5ds2zF/Qh1SfyF/EVmlRJ1YAXmL6YPBzSt/Rf3ri/Mu9DNTvu?=
 =?us-ascii?Q?Lh4Mj/b1zGmc574JRvaxdmamY4gvvjnasDj8k5qkqA6LaJru4ID3h1cFsOeo?=
 =?us-ascii?Q?tZA98YJ7gAc5mrG9gD0LGSjXJ2sHYlnFUfB2ohnIBhhx64w4Rnnua/fXihLw?=
 =?us-ascii?Q?6MWoZ1bXfcsoVgCI+wUdZpIErWBE+ZY3wBSp8gdE0d2gJoPmxnWL2/B0a2Hn?=
 =?us-ascii?Q?LOYB1nAYlR5TWoP8gdj9Lr3KNclCxVYE4CJpbi7OkY8scMRjb3juZggbawyd?=
 =?us-ascii?Q?FwIfMPTVi+A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BjEZLsNy2sn8YmfBLxcI1xtMGwYpebWQgQ58+Z0a5uh8tVcWGrbwx3ueuAaW?=
 =?us-ascii?Q?1Z3wlORI604Dea/uJQc1y8mW/huDoc8mBBbR9TzjXsW6TAeXu5tAWdZwpBoa?=
 =?us-ascii?Q?TbefSUonfbj2hG4UvdYBC8Kdc/hp/LCopYX9Pn6j92DGXKy6WWpNL1x1Biux?=
 =?us-ascii?Q?+SPALtXVPIsQwMPTT8CjsamHpOdCJCPAMRXC4wRqmHUZMsrXRWPcAJg89RDx?=
 =?us-ascii?Q?DHRoI1zzqIhgpI7RgM3QivPt/L0aNPLbVG2BakbQlgIqckOnTyPlDJR5BCK3?=
 =?us-ascii?Q?RYEg+o8nKfOGroN+9BUXa/V/yv42HWyo1H6kBcfacts5TfGhRApifwBOwQf0?=
 =?us-ascii?Q?y78cAHcoUVSmUTtvhXzndwep9e990JnETqSANwo47MXY3KSlZlW14wxg02Fa?=
 =?us-ascii?Q?Yi84I3i3u8Bc4XSkE87MJtVGn1kld5zYS/GlD5h84llELWTOYaE9vmNOdV5s?=
 =?us-ascii?Q?tf7U7gp7T1O+6wO5Orumt7kb2+QHMGgKfpZJXCpWVEvjiUxzKpZEHEvL4KH1?=
 =?us-ascii?Q?hmjM2k6XoGZdmaU/otVMQOtLwkQlWyWA4Uo/umxUafz/4N9JvpYjdHvjt9hn?=
 =?us-ascii?Q?jUfrR0RXYMtxlxgdMtYcVNX1e/DYNeWYQAju76wx2hawK4wHvL/xO3HoHr7/?=
 =?us-ascii?Q?11Mei7UA+b8zFPzHoVWebvZvRS7ZKoNfkCJjk3E5zgkDJ8j6ECfUbhCXZJtD?=
 =?us-ascii?Q?4pDnSNReOAnfVtV0us1vXBcGQFABMxKzGuZNxERVjdDhbyLDAZsYk5lwtcZR?=
 =?us-ascii?Q?hg2V0WLSLs3pwn1SRKTSUHYJ1d2+sQRsRPm1uQy8Ll/BCoajz/gl4ZUbkiHx?=
 =?us-ascii?Q?Vgrq4fWRPL7cWtVsbiycNmBaHDV6nWLnKgm1HUMPbemSZGvBCks62Ww4Wlcs?=
 =?us-ascii?Q?3umDgy3ee/EB66fFSvPp3mP/9JN4TJTnPu7gfGJo3PG7rmTym7igc0P8Gg9+?=
 =?us-ascii?Q?STAfP8VxtRMQ12qv6uiR+Gnif3ANVbsPoo/KdVBwsyNbZQkt/dUrFfPjtdSq?=
 =?us-ascii?Q?/h0+Z2kq8pPO+iQQY6pvWXizgkYkGapSDoAP4YRXejpUS5c13HQAeseNqKjI?=
 =?us-ascii?Q?6hfm5hMyJuOuX0NOCKshiVpLaC6VvcnqGFs+NYEtImeFJk7O4f30Y5Ka3Khn?=
 =?us-ascii?Q?1ts/t9Viv2UZCO7G+L1GjF820bML61upmLQYpeu4uA4fHvjxm+i9BoP7sQ33?=
 =?us-ascii?Q?16f7wOEmYbiETHb6+YdCWOMvn8JOZnpPC25R/O6rg/o/8+EnkyV8zDALbgcc?=
 =?us-ascii?Q?67NjpeeB5uG71wAjJH3xzsOMW0Lv2lGQx63pVGg0IDh/bgwlHjhCxAca5FIx?=
 =?us-ascii?Q?Qgaf94NJG4H9qbJ4PSOMAcKycw6rQ/5lVAsMOiDDFl/h3zgvwUXjXv4+hbIM?=
 =?us-ascii?Q?G+Ik1xFqy5V1NeXOf2atqbme3+fR4VuoYAzwexAJ0slmIdtF2iX+OquZBu2X?=
 =?us-ascii?Q?nASgOZCVWIZ2bf+f8XThpa6GtB+smRaC8ZOuSErKw+GCrja4tHF12EJXJkGU?=
 =?us-ascii?Q?xCh4/q2Ewk8X24V8xBxoRGjiY54KGVii3nTEFGgBy17aEhuCgv34FGgsXJPx?=
 =?us-ascii?Q?WC1+iFBmLDJtaj0vPke+2M3IIzjIzvgrXtYgWkhQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f1da59-814f-4cfd-d5e2-08ddc9472d77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 17:42:50.0415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0Bit1J8l2qOG/7JcU+Ttiah5fJQlwajt8WNgWYPmjAZVEQgbqcUhaRQx3UYYr4x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7782
X-Rspamd-Queue-Id: 4BEF91C000B
X-Stat-Signature: 8wobrca333kzsfp5k4w6rd6ejbj49636
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753206173-524760
X-HE-Meta: U2FsdGVkX18dhizy4OPPw3viPQQnANMRBy7oTQyQk23ztfYXIijxUbkgc+WDEyeVWwD3fX4AwBnLQknt0bDHdtEo4iwei9CamGIFUgkEXYpNLpqwg8GdksxmNnu4ueTuX1KObklbuzgyV6+UU73pgqC54nSEL0whAuQQ4roA2Uw9GJ5Ao+zTxiRSuJUBHn+z0DPlSZme4MmPCjCtGrUnt+1O63oUjKDtkerrR0dKEa4PtN3kLhU1ex2d87Fc27hVGeuO36zusxGxBo1p9Y5NlaM6WfYvbOVjAiebmIRaLb5mDQxupkc2h1uxW2gTtn5e2ml3FfhW4qK932aWye7FhtwOgKYUgOut6lkKs+xgIwf6SVV5zaAahqTPk7L3Id0fZfVZ0zUJDI1H6W+DBxDPGQUcHdGFUFV4f6Y6HoxRnnuxtmicpyb5n9AjmNrrIG+0gQX7IOP8TAs9rCqu/i+t8etzDvlSPE0ey4hi/aXrU4yKoYGdwN34/7q0YxtINgM1DwB10evVOIYSn/Rp2p/qnx3QGatvzUYB011yZ1fWsON21OII/n4PM2IyKr1ZRg2t29PETd0GHX7bf2B+hGqttqopMePtAEvtABfWxLPlJ8am67T/WWxtX0Ev89oESBegre9BRNfA06MWHVfsZM5j3+M8LB3IpBFY7JpDO1dIO5/wwgdXF2A5z/Tyz8MxINwkLAHAHswhlXbXTiYneSye2HT0gmKYu7Cnnq/Z+jFW3nTsJpo3xgpwRXO3o09jb4Lug7oxXnYwlNaH/PhPEyZRtBx3dCfJIenkKdqv36CZuwA8vrEPuN/KFVV/g3REyEzxxnuRa+UlqWCzbY1ZBzg7ROYqe/A+AE4bb5fwGgPPbKxxtfIpz13qyANHDSICQDTcEZyyYTD37LGGRhAVilRzhwsUv/Aq0cwrEebxEEi7g2JtdOaDGmbphmAhFZuyNGt1R9UMmjlP+UduG1P/fY5
 rV9jhgRB
 n7OEw+SKppmpt2kbuUHnxucyYo0m4+8pIrcDhHdRMlnylb95cXUqIFccJsmYXbuNgsHwYw26y/rrr2oaBK+xEYpL1ZcUy8ycp4EEzI+VXISyzkhYSklu1g6jkZ9vZ2eSO+SuVdUuglOd5tEMHfkdGUWA1f6J7xQXEEwfPYWDYcqYknUHoXMWaWhQXqtoH8aI/6FVbq5LDyoZa9xLwvt+ew+8ojb5BOcuPvM93WCLMvriwWAmIPb5VF+Yy8m+OCzzFQJIhCnD+dlC39FrAvOYR1VrVli8Q79aH5Ry5m9Zj4V39HGasK8H/zc/qjy0IwjuG8reFKhd1TnimuPD/Vyz9wog7Bh8RU+DY7lsIfnU70ppXaUKWhfh+wIrSfPBhyYjzbkhnSla47uA9fzEXuxIvaW+yhWPNRjI6Ugysz0ehcAwScU4K1dbRBEUQ1plG/ilRr3hmAm6p5ow1ZtpMs3H+piOk3+7ABCh9yaZeFSEjouSlf5nVshPx3M2K/C8xCxaaH399
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Jul 2025, at 13:41, Lorenzo Stoakes wrote:

> There are a couple of mm/-specific header files that were accidentally
> missed previously, and some page ref debug code also that ought to live
> here.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..703f176315d5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15879,6 +15879,7 @@ F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
>  F:	mm/compaction.c
>  F:	mm/debug_page_alloc.c
> +F:	mm/debug_page_ref.c
>  F:	mm/fail_page_alloc.c
>  F:	mm/page_alloc.c
>  F:	mm/page_ext.c
> @@ -15887,8 +15888,10 @@ F:	mm/page_isolation.c
>  F:	mm/page_owner.c
>  F:	mm/page_poison.c
>  F:	mm/page_reporting.c
> +F:	mm/page_reporting.h
>  F:	mm/show_mem.c
>  F:	mm/shuffle.c
> +F:	mm/shuffle.h
>
>  MEMORY MANAGEMENT - RECLAIM
>  M:	Andrew Morton <akpm@linux-foundation.org>
> -- 
> 2.50.1

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

