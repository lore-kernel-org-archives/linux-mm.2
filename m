Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D468E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1266B0099; Fri, 30 Jan 2026 16:00:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6196B009B; Fri, 30 Jan 2026 16:00:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0586B009D; Fri, 30 Jan 2026 16:00:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C50C6B0099
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 375195AC60
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:46 +0000 (UTC)
X-FDA: 84389849292.18.B4B4347
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id A672180014
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n2ulqnto;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="O4ri/6b9";
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=;
	b=40w9hqhY8ZJNpp8Lfv76vOCyDdLTnfs7BpgPX5e14BWhqj24bSm4GacZlVN6qp4o1hpuDp
	mTjhz7VslWGbfGJ3nC7SM7bmHGdbUgMxMtfqeKTI5oox6qAy6D1t3KlCXhTAhgwTbIVzTv
	C9PsAC/jcR/6kG4eiVbmUzWVMKVof0o=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n2ulqnto;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="O4ri/6b9";
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806842; a=rsa-sha256;
	cv=pass;
	b=N8tGvrKAk/91qyLQh4EksV249NsVbXIVqWvhVSx+h0gFL1ZM5UXIiLQCOKaAtWl4BHlanx
	COgRu1kZwLCD2a9lbD3MRkiA7o2Xh5GzKxX2FXOGulMtDw8ot6Whx4zCpdd8Djy7ZA2iIk
	1S+BxR/vVyHTr6x212vU/RIB0txvstI=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDNIN3407068;
	Fri, 30 Jan 2026 21:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=; b=
	n2ulqntorzfdt1MtgpaOr184ptdmCvHb5pqpHnl9UGFuX2jPS2sSXlOdMUGzVn9V
	kB5XWS14wmDZkD19NvinteP9dzRR+gZjtfYI4XNxanTfaotU/w2XLhxyhzv4fn/E
	nqNGyZsN3sBsSPT0l1jGk2GbREqtNiZLAKv+KEOldx52uu6dRbFjuCD0qD1c4jUm
	Fru2CqNaNn4CRGawHVqCyFAAskDogULb0PMmGAmMZiMbHm3eth9mAhzF65Nu05m+
	xOvKn7HF514Guwo7RlDwiOmmQf1thXrydeHddP5IGYolvKhj+DiJbsNzjY2T0Xq+
	/uSMgDAUtZguLys2Tf4wDQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c103e8du1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJgAIV036086;
	Fri, 30 Jan 2026 21:00:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhtexc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EOqYlp0UyC0Vw+1IRItHfaaZqMEx6pw7ksQdHx740CHwm6JeHwsLQGOst0HZXrFnB2wHzCnfE4n42WXmCfb+/kPOr1XgNuHVW1tzahFNgUsIKcs3nC3pJpFMLSo4BMoKyAq6cEc1xiVVFMtMjRTVovfZHNMErELntRg8atr97xe+pp9oujm9mit7I6KbSCK0iCA8QAmkabwjVHbRUq+E8ULMho2hJVCk4COu1MVE7YmdStxxQFrx6JQPbhit7LLkXss1vG6Behr3+c2tln61tKOn6zv9YrEooErkcJ3YkYK8gWXMHIII2DqS/nouHQ/fcPtaYwIW+W1ka63flLTm7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=;
 b=BcftGZ7sB1UhRqCM8sDhC5AKBqnM0cql5HQ9NrLulU3UljMJICyjmkOXPk7DTqaI1YaqSUyD3lYU69PLuSqzwTHhsGngiSJ/CpNJ/wXdpoGmZT1O+bhyjl8zDoxoFZdShcogfqlRbHnIh3dbeOMVSdNmkEoenqsQ0TclyFclpafMhhiO/OnwUewUg30g5/Q0K9PGkXfdHc32JzLRcfWdpAyiL5E8rsBXCkfSJe4FWZtyOiqsS1Oth7/Ac08d02QTprtV2XsV2hWI4lTF/5UDXPLl2BARZy4d/YNeurDO9NpD5JWzyPk63I+8Ys2dg/xw+d0jQ97/2eAykUYJp6j8ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxV/p2KqJn2g62arMPazK+xNgyy3Zs5cGjzURR8JZIA=;
 b=O4ri/6b97J511jG6CQJ4TvpNqpNN8S9i2klsN3ZPPGV9V1L3qiLJsXc9lSrt4K3WTBDK1sDxm0BVYvBv5DvT5mNThT/72PCtHU02qHq579zCus66Ip06objGyiJ181xCOnLGEn85Q5UkOCluemlyjIuC24h0YauCJOCkXYgdrv8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:17 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:17 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 10/30] maple_tree: Correct right ma_wr_state end pivot in mas_wr_spanning_store()
Date: Fri, 30 Jan 2026 15:59:15 -0500
Message-ID: <20260130205935.2559335-11-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0461.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: ef8e46cc-3743-4421-2a19-08de6042928a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KEO+9DyHBMFuKEQLKucHaaMa9kDWvkLCULT1NwPb4XYLjviemyib4k2Lh7Pk?=
 =?us-ascii?Q?xUfNKLsSr0ps6tMqxXVuaC6DR5fLwjPTc0NOjS8xILeKDmqEvGRDvn0XTZHm?=
 =?us-ascii?Q?xyxdZx4v3xjfLobvkYf7z97e+fZgWglZB1h/DIwRYzTeHa1qtwyWGKbP6rtO?=
 =?us-ascii?Q?9dooBHGwm8HRel8nekOj31TZ6IKKelbDN56yU5x074ZQCUQ3RuOSsV0YCpB/?=
 =?us-ascii?Q?GSJB5jEoe8TFDeYiaK3ciZ1dH5JjV5sIojlOc7qrWkd1un+5b7eiYDY5VMtF?=
 =?us-ascii?Q?+em+o9idcHoAyyrr/E+PuzobowYOzgOR8+axPfoBekeM0jzBgXa6qOMxokOe?=
 =?us-ascii?Q?IoFrkZP2MZ+hRukYbvjZrLbPjRxWGwp2pk4b8Rb31ZJYvM+HTFJ5oCt3grHZ?=
 =?us-ascii?Q?P0et4U37XhpAp4vd1z3AwQwqxekWTWJOSfJEbqpXQT1AGP1d+1v4+8sBePkr?=
 =?us-ascii?Q?yMMwF4qvqxhd/k/VQJ3g9cXp8nZ6uoJ8riaMpNtdaszRhxnsJBpGJGnlDFbn?=
 =?us-ascii?Q?t8Hmlew+/eR+gOQMBn7bxlJAYz2qXaC43HbCj52Mmp5M/c24er1b4Upfe66q?=
 =?us-ascii?Q?BHWH6xn67cEIXPozv8YIqJ0JoSC6at51pymobgNkqcu7umt8xz/n2kGrncKw?=
 =?us-ascii?Q?wlT/D6pcVuL3+MzLY2t/WHrCIzRItYnN3jQFV5WsuEL3hsEkxwzb0DHSnkPo?=
 =?us-ascii?Q?Qke+NGChJ3/nP5jy7SopFQTC2ulAiN26zy5k3SktIRXKtqFoIqtJRFtl38iI?=
 =?us-ascii?Q?Gg5goOE/wLUjL+sTxYaCdWCSmOQBq7dBTHbLuAcZ/ABQb2cMjtJ/lsyw49Yd?=
 =?us-ascii?Q?XomtQEM9DaA4t1hXPqbsnL2tEIqtrkQiJ+P/+oyU1p+yOg8p/jcPSbrCZ3k5?=
 =?us-ascii?Q?RxT/vHhqtAOuaWwPdGLzrhAx6G3pP95bmvIbqc/F19jUbclLShwUqfbxZypw?=
 =?us-ascii?Q?P9sHpNkccgPPVb0Oh7JvuCvfUhhKj9SQIPZwfH8GkuPrwmQWYWaiYJ2i6Fun?=
 =?us-ascii?Q?eHxYO4oqBHWrWMxl/ckyL89x3wJhnNUTI7sRh3tiesGAF7nzGTV3L7NI5Wxq?=
 =?us-ascii?Q?n8QUz6YaKI5mQOGaXudNBk+dZJGAGDBU2RxGEOrI+eOhajljGSMFS4OmjL93?=
 =?us-ascii?Q?jRRfguEqP2xhmi91Bs5B/fc+LiS62NFg6IpFf928IzSKUXyeY80h9aTtD3cN?=
 =?us-ascii?Q?J+t8xXQY5L/PcltyEnqCvEUbtTfU/4MfGluUnEsTHcz5FAs2AXhwH2bLCnAe?=
 =?us-ascii?Q?O689MqZDQeeaml+UpIE8LjVzL7Zrse5lNpusnbEwhzTrEXKALUWMU48JtQ8N?=
 =?us-ascii?Q?dfeh2er9Mg02kkBJFlRAdTsgCza7apQjPC1lDuI6BbIBH32AaQps4xbwprd5?=
 =?us-ascii?Q?eS+luvi3JKli1PxxFn0e5Nu34NM3R6TNsVu3UbsPjKopAnnqpU9R0kPlS0Z/?=
 =?us-ascii?Q?VdOooJ2nw5UstwUOmS3hNkcCcQ4MCvXJO2Vm4aeAA9O1NLCZIIjjVZi6FdOQ?=
 =?us-ascii?Q?fcZEw6t5o0svy+Lbh2UD7jq6hwqriiQD3RouFGlM1Ct036mS0VFAvv1NoH6s?=
 =?us-ascii?Q?B+nQCSEna9HLmRZkZjY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eYTt3bCqGAJXnLfIpJ1vEwmMgDJQ8M/a2UQzGIzE8lnPl1JCQN49sKI/bRkW?=
 =?us-ascii?Q?1rvifRmZ/sza7vEeS0Rzsavz0O+jCDtqB8Dg8S9fn+bwArDAD+w2jqOWtddA?=
 =?us-ascii?Q?j+tNXIL0HDu8iOwHPqXpU9jNAmuSFdsIC2MSuBkBfLYabfFAVchPl0MzBHy9?=
 =?us-ascii?Q?FZKtNVFMljAMeUSdGZAVF7anuSVrNF5R14xX5fd1OmH6KeNADZtWNuB5j80V?=
 =?us-ascii?Q?4bq3HvEx9sGhTnGpN23eUcw0b3Z5nkxHGcQ73WQwG3kTAvErWdag94SaQHhv?=
 =?us-ascii?Q?xr7CqViHg9iR25gLaZgCUicuKcdXvtGnsWnZLoSkbldMEDwyVOmCpqQZNl8/?=
 =?us-ascii?Q?dNb5h9qyYe078CInpmGfW93PPHzyiRtq45tzeuXzVCHXijSClzu13j03vYgP?=
 =?us-ascii?Q?Ma04PFIFC+Mku/vK1YbGJzdHahBCDjIM8PO0ERzXo8sshjLZ3otttPmi70lc?=
 =?us-ascii?Q?6egM2Gt/c+s6LHl84JR/EqX6fnECAkPGFLV+M0g78DCjfmEkGms1T1jKwT54?=
 =?us-ascii?Q?kd6x4S6imBprzKlvmmBWqwqrbPsuevQfft/3BSfSbivYHJeVG10EdSh8F5u6?=
 =?us-ascii?Q?qZDHglbQLiVc9AKrDBy0ZjUPjlOFeXxMY41s9jpw9h9nRZCwm6r6X27Lw/nY?=
 =?us-ascii?Q?025OghgGTtTu2wsbXItF2LsqKmztk6UIaL0XoeoNGAoVBNVxbujyCl2NtDPt?=
 =?us-ascii?Q?rQfhwbD7I/wMG/r6s1R0UO35bz/12YejmnA7PoTEQOOKQgyJ/7mlGZJglyGe?=
 =?us-ascii?Q?/cuMa2V2Ne49pJGLY9sdKFelChha0Eg0jfLIUCwdbqwTdipFTtsyO7G39eqc?=
 =?us-ascii?Q?fAU636LJjkk1bshMml/aEiB5zY2VPwHnBy9A58cs9OvRxsNQkojA7btdRAA+?=
 =?us-ascii?Q?xQFl0YUXL86IkC9Guppn7K57UFx6NpB1XoR8ZKT1mQXCNMd0dEdnpsrNFHsg?=
 =?us-ascii?Q?q6CYFEN8NR6XI09KYm2Y1Ku4cgwazaDwA001U/p39W9myAAgfi0GgqabwRkH?=
 =?us-ascii?Q?1trm01WZRVK0bCWOvANFiEnzVh7rOrNigayUsH/xO1AmjnBo0snPvWkSYR3Z?=
 =?us-ascii?Q?aNp60WqMUzj2mUk3qr9kOvaCneIVXhGbIDyvcKqUYTdwx1ByHufUDe0lf+Fc?=
 =?us-ascii?Q?IlTR1Y56c6Ju73evIm4BfJMR8KoTD+sCoX3XGTJ3r7AdhKRQf5srj3x89hcN?=
 =?us-ascii?Q?eepHbzIC+q/EEzqauowaBXuDwKSjKQ4Tvz5jtTUvaeMGNoFgVHnlDRl9Vklz?=
 =?us-ascii?Q?kkBoN3uPQlc7X5GnQO2z23DNgwOrvXb1EQKuqsJKXg6R7jOBfLT2VjIrGAWd?=
 =?us-ascii?Q?tU3eAOlaOLUsMyxtFoXoVGuMbzk0jMGGxV2OmBFnlcDtUh2mfmHdd9nUdWUc?=
 =?us-ascii?Q?0Le9hIBYjf7RgVyKX440s2JFmFH/AiwLMA1AnFDp0i7ZmJcbdGa8C9s2aBnM?=
 =?us-ascii?Q?dOVgnsJ52AY47DhBtL552tGo93NEm++ELu2Zoa1wJ3xGL1Il+0cBtahdOlyE?=
 =?us-ascii?Q?UF1n0J9BTtxr1cSY6bLE814hKU0cCFtXlgl1YaFFg5qLR8oF3UZvFjRBEBmZ?=
 =?us-ascii?Q?SwBTCkzLLoKTXxejjxc993DscKNBckI/MeG/lu9K/4A6LwBV065Q72LZ2atC?=
 =?us-ascii?Q?4fK0rSIV3jAmG+KOmS9abpImjRWNe4Yg+LC7rru9jOn2lzkc61hRqmaPl+ie?=
 =?us-ascii?Q?bwGrVzTCl73qy4QpwtKznj7j8k2C0ooC3rHEGr0t88ovXa5bZS8j9x5Kpyq1?=
 =?us-ascii?Q?EaZpcdt9Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S8GzTZB+0wae+hAaGEjXAqK0tCiFDFlyBhQVavZNaLVaLj6qjf5RqglLkAq6Ck64Oxlh77GZuDRjBpYjfNK24Zx091kzhH7NqME6kIOL5TdznKnRC+65WjVmb9/cx+QOvJU+D9Dmu0oPuMHyRZNmHjS/5GscdDBYu+e8qOZsmWZhMzNNGkkNsyYsZZrpZd+VEG7dIGu4EXTR5m0P6gDFIm/mujHMhHBgNYLXFI3iR8e/DULt0jfXlUgG++ZiavcyGy8PrJCL7rIg+sLBHPPLh1d0hFe/lBGBtnrI0PQ2Rc99ezMb4hOn16/ZzdA7lvgg5ekgTriHLVcX0MccaFo6mvU4tNRMpjbt6Q7hLmrF1SGcAud2CehxY+wbXGvWPTT6XL79M+EygvUCcQll9j08dGvF7H8a4NWLHYGgW+lHeSrd20EUF8UuOZ+SkJvPkYtHMggraaOmz/ZvqGCt9Fiytv1VcANukQ5QswjNzbCTtvrChmrDoZZvhLZ5hl5rhPlEHRqjOx77eH/ntrCvdszvgn6mNcwx3ZYx+dNLoDjFFQqQApGEKMA0bmkAR/1ohQ66mHWl8D/EHNB9ZcoAMHNwG5wTt44BmaIbe4F5VFyx1ho=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8e46cc-3743-4421-2a19-08de6042928a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:17.6795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Y5ydhHNCcof/gnYVJpdxVK4jDq5PNLgo0p/NWDXP1+UPGJSThXdps0rRXl6Sp+mQZH48eGkr/hLQjT4acrYrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX77YDs4yo5gQI
 FAuFScK5VCgMkEXjqacqG17uIsKQ6A7U/z35YPxDsE9DOXvtDoIvSgfipgMCJ7cDlc84U0S/K8j
 qP8eeq+deN4C5N1mkWoXE7nYNuf5oNU/GQjyqyoInt+QfBAkis2ryNqg7Gv4Rixi8OKbB+82Aci
 jjwtqHllxmXSCV0lk6VBV7Xi/TE/7zqFmXEon8l88J471BHkre+7wxNu56gkROgasx9Y3P66oap
 BJCRCZbO8jXDDRs11Iq64WS6tqFUr2ZGwppr2rJkmHcunXB7vhtRfCtyrrrIvGBpPIwnArQFf+r
 eMBbBFgIfRE1db1jeFRqzL6NapiJ4kswUnE+T3b6iVmABgktkIrlXe456Bw33Cb5cifW7kwS3f7
 qqtKkVXsBFelFqyNZWsS/EQH+6e+mxDcgIYkCR52d4AVE6FgxAatPLKoepcCg7ASO2QCqbBgzNZ
 uTGhDhJBeun3FLkoshmxToydsZf93igqM4N+fRWQ=
X-Proofpoint-GUID: O5EK-VxuO4y9zSdS1HsHU729kBjaHK9Q
X-Authority-Analysis: v=2.4 cv=M/FA6iws c=1 sm=1 tr=0 ts=697d1bf0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-8DI_9cH-nddbzlGVogA:9 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: O5EK-VxuO4y9zSdS1HsHU729kBjaHK9Q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A672180014
X-Stat-Signature: b3awh84rkuxb9wpb9gbd7xce51synt5e
X-Rspam-User: 
X-HE-Tag: 1769806842-498522
X-HE-Meta: U2FsdGVkX190y0EEdvY2Ph1NR5YFrHZjUp6n5Y3pM270QRMQ1IcowQ3QAL9d9292i3wgMfhOnX9C9gB9Hq0y9Pk+5LgMw+X1diKNNw8lWquV+m99Ky3M0uWEee6sMXw65p7KR6OGeviH881ub8AHJwf5gATe/R7D5OF+YLmM0dQQzTMtPTDEsuyIH3E85vlTgGw6mvgFeCgN9NuDkLWRiipjjiXwOv3cEG/Fg9axVSSkfwEhksEaKHF2slbfUlgAyO1Ln33USpRX8BrKoYubVdzKKZGXYFHFYOy2sxMYOkaC3GrkZ6QWXUTd89R1M3R+4CUpxpKZLVkte3xj/I6XtKhLZHvmXRa5PZv9liM5cZIy9FhhS1y9miDOHpCYppnLkuKQR0+iVlzn09LabTv+6FZeu9xDA5wz1lrRFSkBnuFVdSIeQ/uVgUBFn5ZSE3qeFSwTsetE9NaGnauMfImlEF3qI6k0ZxTCSESy2uZbQN2FWdDtZIxVzN6OJDrm2sBxkcYPhlRuPydQFD55E1ACLQHs11DgPfjHy7hRPI47PP3y291zVJLqGqm/sTsz7kRiAGZeUNsqvLPETRcf51Gs3teNTJ92/Et0LudZx8CF9EYOWaq0Xra24uYCJP06OVMSdplzIxfrgeFbSpFAbqu5O1mpQpCP8fzoPHYGsY+N0Mw2ppjIo6r7UWWozM/XD6ScZQ/r5eyCeylSpUwa0OL8TADXEbzgzgo6h+5OMUSAnvK5m5XGZ8rFRAYMfG4t0fTbX4qtv2N2tklQTWQtG9UOL74WmaTRPzdP0oZmaZDA9nwSAvuo1m6FHuYdIxDLqJlMynVoXTV8UHhc4xNbsIoiHfcgd3xVUkl9FFo5+h469JoRLidQWLpzGZb3IKEcMcWK/hja3DCr76RnABREvHN96K6+vxh8aoPicQORuP+JBO7rwIiRhu5tez8J+3KbZbtb2lcMEmq6QlYOZbpOdTT
 FjkYxXFj
 wWBql+xRDgvceB6y+5wVd9W6nytVfQNII6Lb59GLm9rjEKWGNQ7IedS8RhxVL5W2tjuIx2qp3mEMphmLh8809CjkPdbj8YTx3UU7VKyEMgVn61EIcdo5gVUYYIzQiPZLojuDVao9lXtN9pcDE7/m8im6aJyC6ZqbMIxYKXLTCm0KMCmCJFEh5zDdLgoRbmStFGBAEKAp+ST76aoU+ml19HIToGCkYpItJFdCll65X5pgZh0yW7KCH8fkj8Cw8K6NRqg5oM37fogN5OBkT0BO7mspIzZJrLx/49LQGaqOOiNOoOvKHoSRGacsBvJoJhFg9dknbYqSE8tWWPa+viITUiH3Va0jBobPVtxc6DVgkPeIAnWCd9p3j82uMmTEPl8WI3WVhlHScgn1Y74Jbm5hltMJQbS1QFwOZD9kKfuKfl14NIbc9QsRZpEbgBrLJ4CEpEWVkrIz2o+90BzNZJwpVwhqE6EBFSiyehks906Hac+3K+u3dnrmt2nYI4K0lAasGFWLY2F98oShOjQIhO1UmBg0tiihU0Bn2qqvNuIWIb9IdI1ce2F8jJSiO4Olthksm3pSbhg8NQ8nJHta4nyl3LZWCOGrnnqZ4BkO1B+LlPIIe6I2/LUH3ZMZI1UgBZfGWlGlYM5Om2TUxD75WrjbFamEf/9dCWsnEcYfJl0mBb/KMOrBpX1QMNk3pgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The end_piv will be needed in the next patch set and has not been set
correctly in this code path.  Correct the oversight before using it.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c5bb341da5e9d..caac936bd8d40 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3494,6 +3494,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	r_mas.index = r_mas.last;
 	mas_wr_walk_index(&r_wr_mas);
 	r_mas.last = r_mas.index = mas->last;
+	r_wr_mas.end_piv = r_wr_mas.r_max;
 
 	/* Set up left side. */
 	mas_wr_walk_index(wr_mas);
-- 
2.47.3


