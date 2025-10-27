Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845B7CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 12:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF20B8004B; Mon, 27 Oct 2025 08:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0CE8000A; Mon, 27 Oct 2025 08:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4278004B; Mon, 27 Oct 2025 08:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A449F8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:29:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66AD812A62C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:29:44 +0000 (UTC)
X-FDA: 84043825488.14.916A26B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5958160008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:29:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ki0QQOHu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KNfYGjuC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761568181; a=rsa-sha256;
	cv=pass;
	b=jVlOTrE1iFom/SBZnaxZSFB24X+j9BGlcvsO0xZoiI1iwvty0atLTrHJU+wkexS/Kr/4+u
	RL3uoGperJWTS5vfYpaTFavuh1vQOZFjIT80uDeLjluoMMMDgJ9kgjjRf8Ct1CxrVWAB4W
	3S+nD7nwvRBtTsJJpo6Spzg9cufLexc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ki0QQOHu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KNfYGjuC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761568181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSXhpgRJowOq+kq57W/4A+rcpEOe5gphRdse+tFjt0U=;
	b=qpSnxkMFjJydiLK9HrfAZE/ATTVGyTTdH73Mlr7dz+4RQex2fmdxRM3Aumk8hZhRpvw0SL
	VC5x2WWYz/+AVfhfZFELOldfJTlNrifqbLBMtBl5OOXI51H7zvyV6/zWUJrkMKOtf4wX+k
	hvL8+Rw6PGcZMWYu4ku9Z6cpU+08o3o=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RCCF29025450;
	Mon, 27 Oct 2025 12:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QSXhpgRJowOq+kq57W/4A+rcpEOe5gphRdse+tFjt0U=; b=
	ki0QQOHuJ5HfVtEfQa6XA+F3y3aFN8dTRdlXMZ2lvrY83n8lxBNUdugFfozfKbph
	Yt5hSdIbVZoAfXYinKRjxyEginTGNpXyVwffoYhPY7Sa5d/Qq7rCozyDZ9/Bmqn/
	ybaXUx7khpjL6u4fGw/jm76kXSkBwI3h0VMfZ0eSydt8yPMbW/vrAhvirIPtQEb5
	xUX67epg/8ceXOUWncUgKeROunTJ/Eu2ugZWA0APEiONa1PIvqUxRN3Tl1OAqDWy
	zkKRw93w7y3XsQFjw3+kOgeUTLevAANDNkkwuYnEJ83iXs/sStG+p+4EJTm0DKdI
	87EN/i13qYar94+INn4ipQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357gqtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 12:29:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RANtcu025102;
	Mon, 27 Oct 2025 12:29:30 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010010.outbound.protection.outlook.com [52.101.46.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n06yhy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 12:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1/IiLepWiVyqx90s1PtZVmu6g+Zl5oH2P7PnhlWXKSsT8fc/ZnTYNTeaIUlyV9GPcSwGOg9awWEgo+zb3vW5QjkxEFws4lTxERySkqKB2FVs+4YZLDW53Bla+Y5EDjVsU9jYtjzEs0E5H92zWMuDboTXfvicxmLs/lMfgBEeceyvreasammd0smEFkS8Ib3EQvvRzyz40EdIu5gIz4JPa7UT0QwX6LPgbPXg7zK3HKnvNNxvNF9t5RanAI+QsUehRbVKhAIso4Igb3PrrJyHmEc7xZ3+o3PvObM1iBxprWwz9Qy0XgohUiOljLCYd309nujoJLgWkIqr0vfsvuo/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSXhpgRJowOq+kq57W/4A+rcpEOe5gphRdse+tFjt0U=;
 b=NzonkMuIDgNA2iwiUD5e8Af/fO1WtBUW3qBQujGzV3Q/D1siNCPNIRTvv8OjNRE6CKAukU7MJQv410TFDl1k6eOJXMXJCXky+0AM1huFKXPqFhGGiYZjxSXI5URwhkWDKgvUFdQPVkt6BimKsxh4YxWIVSuo7bNCWedSAH+ecqLaxoX2N2anBCCcX3Pf6R7G3SLVebiJrXEN+xqD15Uzuv12NmCeYcaX/USPYQ7Ei7thlBuJctPAcFQ2xgRoTBk1c7nfuvRLUHxOwKVKD2s12uDxr+ilLsUpr5+L2Ma1nuPQ2lonLpa7v2siqo1cXx+Qv9AanimmpbRsZtvlCRVlig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSXhpgRJowOq+kq57W/4A+rcpEOe5gphRdse+tFjt0U=;
 b=KNfYGjuCL8EjR4pW1uK9CnyqwtWxf7TxQKZCIGwoSSGlrOhTzQpxZxeEBltbyy0aHVjypoKE26qAw8sIJbrf9Yoq8VbxnrjUDnc6Mm8T93HH6sSMUiu4H0oapDiY2viUX7FxXRMUR3jg9OyHBJq06jMX4/70wxm8NE+9MLx1v5s=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW4PR10MB6371.namprd10.prod.outlook.com (2603:10b6:303:1ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 12:29:25 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 12:29:24 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH V3 6/7] mm/slab: save memory by allocating slabobj_ext array from leftover
Date: Mon, 27 Oct 2025 21:28:46 +0900
Message-ID: <20251027122847.320924-7-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251027122847.320924-1-harry.yoo@oracle.com>
References: <20251027122847.320924-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0080.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW4PR10MB6371:EE_
X-MS-Office365-Filtering-Correlation-Id: cc76ea0c-0dba-463f-798c-08de1554767b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VtcFAmguyuVwLohDnHmc0VW5m9kXbzbW8WIgTGVt0SloK+l5hZ4soIOybybM?=
 =?us-ascii?Q?TGcUb0AOXZj+f8y1xez6rOXRggT4Zg0QV79whc9eZV5vAf+BgQ46lJsgR8zb?=
 =?us-ascii?Q?nFL84U49hbsJuh7QUOd2d6AN2VzPLYj4KceF2F5LHj37JVpXpjoLy5eknkcd?=
 =?us-ascii?Q?w0Hw3LoIlOdUt9NsVMl7ZnHQw/Qxa+uGHgJT0q8LqrB6S8vGrJjCkxqPvXhm?=
 =?us-ascii?Q?666ampRV8w1/5j4JRXRKw0frOtd2mV/u6PgLxSimaOr5zNYE3rhtILz+e/80?=
 =?us-ascii?Q?DtVk+JnP2mHGhsdARxVxk10RgzSFKluwKW6Y6ABMY7q+UFfa36+OrCXmd5pu?=
 =?us-ascii?Q?ehiQSeyNV5KqwqdO0zltYp2XQMbCdNcUGcU86f+5nAEjhqEdu/fHGvkIiO5b?=
 =?us-ascii?Q?S02+Wv7ErcZPpsJojOxEqz5yZhzwDV7+fa0FTIioS4/ovCN97xt0mzuNIOuJ?=
 =?us-ascii?Q?jhpWsSmdf6pNhRp6KFN+3Uz+XhSSVuCN8ryRDVE2YNOVzE6OH7cJ7T0/eAvz?=
 =?us-ascii?Q?5NbRRIoMVTQWunstYR8KLEv4OM1mIsiKQe2ME/D/qis7tQhGkl0LZcn8yl3y?=
 =?us-ascii?Q?3Svsb9YQ8fy3xwCdjNBv5eZZHPgoieLWb0H3YE43V0fdF+jpkGq99jipumlL?=
 =?us-ascii?Q?iA5yx4DQ3Q1y15FU9xZna1NB5mVBNs2USR9L+cc50L+YW8K/YTJOORch3UoX?=
 =?us-ascii?Q?LFoaQc41tnUpbNCbKdqXPc/Mt5D8yMmEgA21bzQJ9j6af8QEi6Jlz8K8nHo5?=
 =?us-ascii?Q?RsdfeAuDUBs8WxRhIT60CWZxu3AU7gTkzxT7TdBwZgosd7ySq+s+7QlVQ0yf?=
 =?us-ascii?Q?rYdK2VsuThy3dbBE9A2CVcQvxar4qmiNiqZ1KRspU9KCaZyMzS8dLqOdM6MI?=
 =?us-ascii?Q?Q0+uAG26hBMceGFEHim+JQMcmXm8My9lyxoP/b0ykzxKgp1qzAQkmX3H3qYJ?=
 =?us-ascii?Q?P2Rz+dtKeSbdZQygjalC1CQkblIJufM4KuMiN2KVGJ76Ndd5BZCUWJ45+ifD?=
 =?us-ascii?Q?AwTA9Ip/1Us37s38rg51H2KgAJS7R+oYTkUon4pBtby+KWgEE1QmyspTIAia?=
 =?us-ascii?Q?AWJGU6k2BB9hCfcjYaoODXzTYEidke5/Sy346qmY/8Z1JiqrJtbqdAqdT4WV?=
 =?us-ascii?Q?3zYe/yXbg5mjbPNA3OVT48GOVd8TGB2GSR/7YcRHiKp7hipqK5a8MG0TUKoL?=
 =?us-ascii?Q?dALigctpHNVCtd80Yt21nPc9hMiXC4QuvIudVupmb5eGhBuw0NeIxsMonthj?=
 =?us-ascii?Q?FHXJSXZB4EwN3WDavSGh2IWj2i3689GjdT+yj12vnx9A3fUeEUfg3CgzQVWb?=
 =?us-ascii?Q?zUvzS0D7sFLjYtEGVU5B9FzMG/6T7+1rSzqCejn1J7HO9cEqb5Qko35hEBIG?=
 =?us-ascii?Q?G6uAlyic3TFkpuuzT8urO3VBDgeHreIyrX0t4F+GIZR6ZGWFc58RmQVsvjSm?=
 =?us-ascii?Q?pWCmyfyA1LzJd+lnLn0WIeaQ0U/wgJRr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rs7D+k1aYntiEOmg8wwx95ic8yu3qQx91XIHnbsxOw+stUE5mrYmD1zTl04W?=
 =?us-ascii?Q?04xZ+sxhKAOPc54YT/rc9lP3TwM1p59CE7a29T6PUJp5+bHomI7GKYp5F5gh?=
 =?us-ascii?Q?kt04frtFmR5k+mvr9dPVv12AxzcDI2XrSz+9E4/rcWBb+JIPCH+Tj2B0srzG?=
 =?us-ascii?Q?dyGSdveDd6HiJffNAL/msOsqlBzKs9wa07IGKwjnX+e8R9mk/vgBGmqS6h5N?=
 =?us-ascii?Q?0sDjLr1x1j3qduNqJMCLzopmXunzC8/BS2AvNQKD2/Nx1RPUhNfuRlGepIcl?=
 =?us-ascii?Q?YhHycpjQ7JlwJAYUDSdiwF7RwAt8UxjpiH63AOQfhuU1eR96xCDZ2FfRYO0u?=
 =?us-ascii?Q?m5bu6zIWeYMzVMHDIhAOUStryl9CrwKsbRkdjhtepqR7KfCKidvj5T94BZRm?=
 =?us-ascii?Q?k7iXi49xmdP7KlK1UYrhJC7RhpQsbifc1xmURDmB5Gks68TUtWNcJKLXPTbD?=
 =?us-ascii?Q?mawyJKwLej51c8Ezg7I0YYiiLr+eymPVP2/rOGAzABTMBD2Ht88tdQ8kPthI?=
 =?us-ascii?Q?b6+9WVose4X1ojLKO+E4fbMBR0LSqDV6T11IPmHd7itJc/gGI2bL09wEt/Db?=
 =?us-ascii?Q?fZuDLaHnTbNJkj3cMDgX4te7+8RT7HqmQ9wAYVXtr5tr7jEbBCeeUQB/70ys?=
 =?us-ascii?Q?lw4Trc02OtHFvNuv+4B8el6261bLqMMaD77GVU/QjOvu0h8aXYOH5Ex5zjpE?=
 =?us-ascii?Q?hjugfCYYvU5bdQj8/1jqubIvcBegHEBGVYf93/y84MGsR0rUZAi2qhZ80/sQ?=
 =?us-ascii?Q?SVGwVy9uizOvscbt8bHFQFcnAU92kXSayLT2lSrbrTpPEiQEPjGSlPJrLHbs?=
 =?us-ascii?Q?LcvNOuP3Yjn0UaGPAHWtRMPTfLAKB48D01FyZEvgnh2ZbuU2sNfleRa3qDy4?=
 =?us-ascii?Q?6egij3p0C/yWST88axOSuOXT4gHQzfafaQnLXgezbSYjYkvtkIR/Jxv/Q+tn?=
 =?us-ascii?Q?gqH9KdJykPfleR/9NGO8T06JQTu9TnkMGG0yiMKVVgMoWoTJjxM9rNz5vXVi?=
 =?us-ascii?Q?Eqo3ljPj1SzJusj1JmuLkKjBFjUIJYcSBN/tMmM7qnwCnTi93wIF2JqoalAd?=
 =?us-ascii?Q?tAgDYB0vltxnIegHF9SPq29W3nSNgDQkWZCgt7VWOti8/Mhq50vNXUk+4DAi?=
 =?us-ascii?Q?65S1lGFz63dYSuFXquILKkdCkTI0hDLB+rI3iUTNQ8PgTaBsUtq5mCxzn2cz?=
 =?us-ascii?Q?IrwPxG4Bmsy86Ed8LXIAuZ//fn7atsTdqAlKhSqL3T7Mf7oJevfTPiiuJh1G?=
 =?us-ascii?Q?yqy+vvAf4eHRMzHAdX5eH9ns8Lx6fnjuK4Z7EJ3ekGzaiAO78NjEYunGFpsG?=
 =?us-ascii?Q?0+i97zzJy5tdyALUkbEqkmfoGppnUeBEl2Ff908ZUokqG+IFKy68S6OkdTGX?=
 =?us-ascii?Q?LpTIiGaQZRVmWvVsgumqDmEdzyn6LnDFpVGgY0NrwuaM4XxrdKJjfMb7MDNw?=
 =?us-ascii?Q?08NFHc5ctcj6itImOKSoBZmKifpFMy3TaPVbloh6x5p0Bd9jDXorchpLjX/g?=
 =?us-ascii?Q?ouw8dy+IjnFqu225gHhQN1ATwbLi3zZZjQ7MVuUIOdKPKbqnP+ff9uShuc+2?=
 =?us-ascii?Q?raDTMHd4ETTH9Y7NhFBa5MdPq+6Qs4G7iWp7WBTy?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uvb8GVrTNECRDxgFQWyhOXyTvlFHa787IYqR0OKLwmYO6EVxuQGGOBMrbaqnagNXbC70c1Wgz5xfb6wLzUKvJKIdF0lbWHM2LEGFw4z5F1/taI1865VFx8REHyiGXy0vfN8nh01ZjmBkeY/4F4wRgrNtDATIz3vnXmMF2MHcBQRI0sgwI9rSx9l+ScslnTxsEHmIFIqpcPROnOFARJFU2svrpkOCFXTzHDOr6XD3rvk4HDu4NnDe9AA9hTA13IXU+Po9xB4HH+ATSbSQ/qtd/VnlIHdnxJ1UqUuUVb94T1HAz6rUBejSjmw0ucRlaAXxvlIAuGuDAD+05kv0XW5gkJRgM6ZwSR8HRxmqjA34UCypZ9zFIaZQ7aRMdaMVHNVufjzr5SFFUi0Q2OGHILM1hZ29vLm5zdIjRUzwpNGLhHaGBG2veVhirS+49pCKuhbUIlIO3v+PQu7soy80Ow/MBra4fz3z2aoQJRThy/Lc/6SdRUyo9nYWeJkZdRTQEv1TtGtBtJ8y3Zh4RCq51PF2MfMtvPzdAy/QHZr7ObiUWbQrQOl38AhIGU4lK1Zlv3OAofgxG05Eegh+Ei7pkAIvYSVJ72HhyZ7jSTbLR8rHW1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc76ea0c-0dba-463f-798c-08de1554767b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 12:29:24.6461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZFDcyH4BSX+SsWXcO2sr8TxOdZHUTVz/Hdo+/E+7RS6eRylahiolbNNMv22P35L36xmMrn1bWFu5233DWaBLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270116
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=68ff65aa b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=yeldhbV0fVjYLvCz6hIA:9
X-Proofpoint-GUID: IDU4WYRmjPbzQselmlGSfWLIpBu7ndbU
X-Proofpoint-ORIG-GUID: IDU4WYRmjPbzQselmlGSfWLIpBu7ndbU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfXxKeejNVcmN2L
 yVzo+XVg3UEv9dxYSfPMUwSmOttoMktXl7L1SKU+uOTeNMDF0ymZk4sTz2OBWECHkkj3EJa5r/M
 bq1q6lniEL5aPdNI5P7Ei/E2kyy50GOmowL9RyLuYwovLQHXVmKPubJuutJaOSzf/Dl2TRD81t0
 bFUWa8pnY8pQYBbriOJC8fOHzvCEF+kcCnesq4qxadbOEfIYt1AA/9R0Txiqj2pMlzx80lpgcoF
 Zx8m+G8eshQvFPrF+I43ixQqWphZuMZWX43xjSYimGzDrrE/ev3raO33njIOGcbSxdag6kEeaTz
 LEFSt4QCUGqx3mWc0+7GkUjSK2dFmfD9tCml/Z+0oto9rwUAQYzTkKxb3JQiGiso6IHPVhTAuh5
 itIIct/CxheON1P+F2d+Dbk8hEfEmA==
X-Rspam-User: 
X-Stat-Signature: ofgnp649ushzbjfikkz575ozc13t1ya4
X-Rspamd-Queue-Id: E5958160008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761568180-649214
X-HE-Meta: U2FsdGVkX1+sMucqL7T6aTU6hdnCBtGFIEiWj0z3sAPhiOb5P4HfLnjZ/IMooBrj9t2B8xZWIA4zO6C5njcZ55PySiM1UzllrG29IuLYxw/G/U2WaKR1tpQx/GsUzvED6IWvgQ2SRlkv7sMu22Ly7zdbcBySF0NN4BMeVI3kWTZPbo70CcKgxI9aIKgttLasVeNBXUbBgdLKP0sZAjGZnj9qu9i4zXiPmpvdRdPBWaBF11DlrerBXaEUDmmcAU5xCHE3GS4kf8C3i+nJRFND096AR4wpZ4tw+QotPUa58LuZo3SHVugJ1SuZxQCAKEkX614qpx21e+L8l3FodDGvRz5gbieKB9v1hevYvrV+slOxPcQoipEkpabukSLzqEwXcMrzdUXPj/5AiRKsjMeap6+z/uthSvCbCHER15kup8rNmeglPDf0l1mFblLji7+mHibg/L+LQPIrUILmw48ikyLz1L1mSINbl8/faMhXxiOcUFPGawW+Z+3UJz40AbZ6KwKei4pSWchmjYolXK6w9VyeGFT+ta5FMGUZic5LgdxdDw/VKTYRxhPrDyEW8Gt2iV/l9zXYsEJpixsFSPzgy+UzGhwClITcmEeRWGXunzlriBh/3IyvSWq0/TxwK7PJPJz7p/0LzUTkN0fNMG7AiSW1vA3XPUFtkaIuw9HopNuWcAJJRhWVL6Kij37vwzW/tHWOLXrB8xPp8gljWbu7mUj6EboEkPbfUsIxQsEY+nsf48H3Sd8dXeupeGwZb+Cdyee4wYGSh91KD8rOQuACzIHzkh/BdttmFowlahsdx0Ni7+H7UQtikY+ZbVUQols6fHq9+FArhn6zTv03GnkIIcoI/3y3E7BC0R6/dWxtfZ83hGVDCmTtQC0YucfHKzLmUT58wv8bMkcc+OwOP1RVliYzMa+3mk3kIpz1g4CiGDUeu+50W/ZtFdKg9xj5DRBGLY1GAyPxf2n4dJYOPdS
 n50D6UUZ
 J5R0tVoXSFZBO0oGPP82KTeQPhDzxh+JIuI2vGG/2Rbmc/YIewZG7oRT1yCNSupPUgYxqXX7nbnCWq/9YFwmn0fDsY3uWqowE4F7QcJkIDadRZBPuXuetE8n7KdK5IfMcn5mfkSR195eo8Wr+nJ3g1sFMDUg5k7pnORnwoe6OIerfifdlBC4UQ+5Ua+oTlT+ClHHxIavMSDuBXtPm8VJmwAIO6f9uwkkxxS4v6BFVhW4zjr/CGb/0g3lEI4uPLDraC4zgoSoVcz20imv1O/rO6FdnOQFT9mIdiYMAdbHiJ38XNJOOYF5dMsNew5hns4+c/mgmAzS7YprxJOAHlCsAY9R91Vs1rdXo3tcm79cj6X6T7878+uXlrWFXGFde1vgKNzEzzO97BJ9mj5G5mpkwzlvOT6g0GHCdZk+BAzwer1nn8555A/WtBhApX8rtKbfXVe6sXXiNIrzSfMLiYp4NzBMo/TqPa2+x9IiYyvNTTP+bYY1GU0QfAaTovlJm7Ms5lFWuG1vps+wtmcSrWF2DFR5Bd2F2JIpDKd2XG2K+ifc/V3t+a3ABgf77c7lABIf0HOeD96xM/psCb0UuTpzMPUe40BQds3Z3NL4eZebmDYb5fJE8DXhswm88PY0WE/8ZdDiytQAcete3qpSR8I4loKH9Sye6MCNWHUDSUhH2y927dbb0uZZFk/U/rU77gmYJS5Me+CsC52Gr+mfhkbLuYDTaLmz620nJxdMgghSfzSL6iA4HFAOPsQbZBp/cfGgVpiIAyXXJOtMKPnqsodtK9SVnJiTi3M7cUFso
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The leftover space in a slab is always smaller than s->size, and
kmem caches for large objects that are not power-of-two sizes tend to have
a greater amount of leftover space per slab. In some cases, the leftover
space is larger than the size of the slabobj_ext array for the slab.

An excellent example of such a cache is ext4_inode_cache. On my system,
the object size is 1144, with a preferred order of 3, 28 objects per slab,
and 736 bytes of leftover space per slab.

Since the size of the slabobj_ext array is only 224 bytes (w/o mem
profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
fits within the leftover space.

Allocate the slabobj_exts array from this unused space instead of using
kcalloc(), when it is large enough. The array is always allocated when
creating new slabs, because implementing lazy allocation correctly is
difficult without expensive synchronization.

To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
MEM_ALLOC_PROFILING are not used for the cache, only allocate the
slabobj_ext array only when either of them are enabled when slabs are
created.

[ MEMCG=y, MEM_ALLOC_PROFILING=n ]

Before patch (creating 2M directories on ext4):
  Slab:            3575348 kB
  SReclaimable:    3137804 kB
  SUnreclaim:       437544 kB

After patch (creating 2M directories on ext4):
  Slab:            3558236 kB
  SReclaimable:    3139268 kB
  SUnreclaim:       418968 kB (-18.14 MiB)

Enjoy the memory savings!

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 142 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 13acc9437ef5..8101df5fdccf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -884,6 +884,94 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	return *(unsigned int *)p;
 }
 
+#ifdef CONFIG_SLAB_OBJ_EXT
+
+/*
+ * Check if memory cgroup or memory allocation profiling is enabled.
+ * If enabled, SLUB tries to reduce memory overhead of accounting
+ * slab objects. If neither is enabled when this function is called,
+ * the optimization is simply skipped to avoid affecting caches that do not
+ * need slabobj_ext metadata.
+ *
+ * However, this may disable optimization when memory cgroup or memory
+ * allocation profiling is used, but slabs are created too early
+ * even before those subsystems are initialized.
+ */
+static inline bool need_slab_obj_exts(struct kmem_cache *s)
+{
+	if (!mem_cgroup_disabled() && (s->flags & SLAB_ACCOUNT))
+		return true;
+
+	if (mem_alloc_profiling_enabled())
+		return true;
+
+	return false;
+}
+
+static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
+{
+	return sizeof(struct slabobj_ext) * slab->objects;
+}
+
+static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
+						    struct slab *slab)
+{
+	unsigned long objext_offset;
+
+	objext_offset = s->red_left_pad + s->size * slab->objects;
+	objext_offset = ALIGN(objext_offset, sizeof(struct slabobj_ext));
+	return objext_offset;
+}
+
+static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
+						     struct slab *slab)
+{
+	unsigned long objext_offset = obj_exts_offset_in_slab(s, slab);
+	unsigned long objext_size = obj_exts_size_in_slab(slab);
+
+	return objext_offset + objext_size <= slab_size(slab);
+}
+
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	unsigned long obj_exts;
+
+	if (!obj_exts_fit_within_slab_leftover(s, slab))
+		return false;
+
+	obj_exts = (unsigned long)slab_address(slab);
+	obj_exts += obj_exts_offset_in_slab(s, slab);
+	return obj_exts == slab_obj_exts(slab);
+}
+#else
+static inline bool need_slab_obj_exts(struct kmem_cache *s)
+{
+	return false;
+}
+
+static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
+{
+	return 0;
+}
+
+static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
+						    struct slab *slab)
+{
+	return 0;
+}
+
+static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
+						     struct slab *slab)
+{
+	return false;
+}
+
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SLUB_DEBUG
 
 /*
@@ -1404,7 +1492,15 @@ slab_pad_check(struct kmem_cache *s, struct slab *slab)
 	start = slab_address(slab);
 	length = slab_size(slab);
 	end = start + length;
-	remainder = length % s->size;
+
+	if (obj_exts_in_slab(s, slab)) {
+		remainder = length;
+		remainder -= obj_exts_offset_in_slab(s, slab);
+		remainder -= obj_exts_size_in_slab(slab);
+	} else {
+		remainder = length % s->size;
+	}
+
 	if (!remainder)
 		return;
 
@@ -2154,6 +2250,11 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	if (!obj_exts)
 		return;
 
+	if (obj_exts_in_slab(slab->slab_cache, slab)) {
+		slab->obj_exts = 0;
+		return;
+	}
+
 	/*
 	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
 	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
@@ -2169,6 +2270,31 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
+/*
+ * Try to allocate slabobj_ext array from unused space.
+ * This function must be called on a freshly allocated slab to prevent
+ * concurrency problems.
+ */
+static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
+{
+	void *addr;
+
+	if (!need_slab_obj_exts(s))
+		return;
+
+	metadata_access_enable();
+	if (obj_exts_fit_within_slab_leftover(s, slab)) {
+		addr = slab_address(slab) + obj_exts_offset_in_slab(s, slab);
+		addr = kasan_reset_tag(addr);
+		memset(addr, 0, obj_exts_size_in_slab(slab));
+		slab->obj_exts = (unsigned long)addr;
+		if (IS_ENABLED(CONFIG_MEMCG))
+			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
+		slab_set_stride(slab, sizeof(struct slabobj_ext));
+	}
+	metadata_access_disable();
+}
+
 #else /* CONFIG_SLAB_OBJ_EXT */
 
 static inline void init_slab_obj_exts(struct slab *slab)
@@ -2185,6 +2311,11 @@ static inline void free_slab_obj_exts(struct slab *slab)
 {
 }
 
+static inline void alloc_slab_obj_exts_early(struct kmem_cache *s,
+						       struct slab *slab)
+{
+}
+
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
@@ -3155,7 +3286,9 @@ static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 static __always_inline void account_slab(struct slab *slab, int order,
 					 struct kmem_cache *s, gfp_t gfp)
 {
-	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
+	if (memcg_kmem_online() &&
+			(s->flags & SLAB_ACCOUNT) &&
+			!slab_obj_exts(slab))
 		alloc_slab_obj_exts(slab, s, gfp, true);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
@@ -3219,9 +3352,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	slab->objects = oo_objects(oo);
 	slab->inuse = 0;
 	slab->frozen = 0;
-	init_slab_obj_exts(slab);
-
-	account_slab(slab, oo_order(oo), s, flags);
 
 	slab->slab_cache = s;
 
@@ -3230,6 +3360,13 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	start = slab_address(slab);
 
 	setup_slab_debug(s, slab, start);
+	init_slab_obj_exts(slab);
+	/*
+	 * Poison the slab before initializing the slabobj_ext array
+	 * to prevent the array from being overwritten.
+	 */
+	alloc_slab_obj_exts_early(s, slab);
+	account_slab(slab, oo_order(oo), s, flags);
 
 	shuffle = shuffle_freelist(s, slab);
 
-- 
2.43.0


