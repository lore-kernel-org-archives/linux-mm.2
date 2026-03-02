Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468B4E9B35E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70BAD6B0095; Mon,  2 Mar 2026 06:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E7B6B0096; Mon,  2 Mar 2026 06:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5460E6B0098; Mon,  2 Mar 2026 06:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB236B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:04:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD434BCEEE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:04:43 +0000 (UTC)
X-FDA: 84500840046.12.F1ADB75
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8BC0840004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:04:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cEzGACin;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="i/9MHh1Y";
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772449480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iZmdkC37jqWuSFChTYriLPZwYgJCDM03hpPoBnIvT8=;
	b=t0HLb9+Y+1/f1nJu+gbz0ovyVeUN1zDSttJ5mtS2jFjtVIXtFt7X7mIDPjEn1O6GksxVu+
	uFk97PGufDls4wFQzMDlxCFgZPn+8DX+Xje/AKy/uDVm5nMWbUbBf5s8k4F1sV4Whz9bjF
	BU5yqLFJOBDLRlA+GzRIHFJryGnpgU4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cEzGACin;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="i/9MHh1Y";
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772449480; a=rsa-sha256;
	cv=pass;
	b=oPzVZEdN+ch9PLo+kl1ZLIsTPfxhREKoWtdW94UVI4fdejZJlZQN7fkuF4Xz7CjFuCyGTx
	tvIUfDc9xJOGsJHZwGDSzfAucMcLY1mcrXPw7KYFpXci2xgAZZGNIOORsi7+gDwenxGUkE
	psoPyYfuqWBtRzqxjnzMjZO8jJbA1sE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229ASob1738967;
	Mon, 2 Mar 2026 11:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3iZmdkC37jqWuSFChT
	YriLPZwYgJCDM03hpPoBnIvT8=; b=cEzGACin2zsaKN79GV71qEOpPpjCrB05Xm
	DDyr8aebQPb9rKL+sfsDVu1BN1girkOj5JoP0JqXO7yIcMp9V9O6ZrzxFZBkBZxG
	MWk8ejQyo3hZ9+ETAbLbd22E1zlHU4InWeK+CreW6L2shJOz11JwNayvGPG6Q5Mo
	fHkrN6aQdtsm6CWjpohNAhwBfTZlnU33VGjceK+7cpE9NZUVzPXPdRtV5amHzp2w
	V4HL2mWesS+KLVhkgA85cdlleipNEfUldOHvY/655cDSTGyEZuuseOvJ4BZBZpdE
	z71XfF7T3OyLnT9KhhnF5kA1U2wrhJQkKxMdUrNtoRUoczDvBI+w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn7pf870g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:04:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622AIgQD029717;
	Mon, 2 Mar 2026 11:04:35 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8sxwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AYFH4p0N0JNvaWdscWZhbLX9YR4Apc54JvicD0ifOs8dBi5HLKtFm5gXnBQqrIpY/YF+P+xGbLLDXIeSFFyQjB8xiFHXadVIy1pbnX3YkS4LfA63pKla2DoXO5zHxDG9Sul6063hX5Eq3nZK7lyT9dNy3kdNuB78F8Y/STqlkaUCVkItXQNyqsjbxrnmrEiYE+N+Vv7JNFBTl4KLAsI2sHe5LM+mUmBBYj6fhEbpAUctjrkF9uXC36byjS170gjn/WKKLnJ0OeO1G4BfF/17FUcsxDyYWAhPsLTudU3V9vMg+rGHHO8zrsfIVeCHlZwRX/4N0jHJPNel4qYdcf1OqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iZmdkC37jqWuSFChTYriLPZwYgJCDM03hpPoBnIvT8=;
 b=VbvQBWeH3Nx4+u3IKauMqVjfP85Ov+faNAUGhVHuQgj9sYU8h0PfXKVrJC6dXmbQkKWezED4WOkRJ6UPNdUmgKxLain2EdkkBis+9pzCWCsJMAzd3Dp7hYlIu3KmYI5yJgfzXPWkzaDIu+gWzCbf93vzOOkZ731Wh4RRAqDuSOxekLoGCxz/9LoJcrXcgmGWCe+ucoI9a/lq3MdyuiJyThsPYZAguiQhLE8t2iP2Y/Eo1IXPzW3uPjZujvnuMejjGyHUoLUDfffVWnHI3+RErA5Hqnfy2MauiOdyHCwv2CMwhGkNrNYnb78Hm7696Dj2wYbzN3wNdmIr2llE0qoBfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iZmdkC37jqWuSFChTYriLPZwYgJCDM03hpPoBnIvT8=;
 b=i/9MHh1YKcKF/hI7o38DSE5HIki+g5XNTA1d+MxeREPWE4xVi8mo1K1xb4+KzY/qf44pQXrnJHlaV5AWyqxeBr6DWVAQTffHbxDaJclFwTFCPkbPGh1F6dY+j1bOnDR4c1fGF9FE1g5xChx27gZ4zTKbcijhfOoWa5s2fQ6DZ6w=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW4PR10MB6679.namprd10.prod.outlook.com (2603:10b6:303:227::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 11:04:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 11:04:30 +0000
Date: Mon, 2 Mar 2026 20:04:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB
 ALLOCATOR
Message-ID: <aaVut1GXyhPBXQs3@hyeyoo>
References: <20260302101345.36713-2-vbabka@kernel.org>
 <aaVpbl7Om6aImsMo@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaVpbl7Om6aImsMo@hyeyoo>
X-ClientProxiedBy: SE2P216CA0128.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW4PR10MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 927dae6e-c530-4fd5-3144-08de784b7a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	rs5WWbFy8DibHbRBIUBB+T6hi4TKk3DNghUWMzBaZVjNSEkAeK2caz4ZDaJRzkWXLK/EGmydesfpf69GOcZMXLzNMUDY1Wmf7zIIw8rVfX96b6UgZYeRvt7/DYZ5Rc2VbsYQ3IcJkUEEjjorYHANTmsJGQX2piPZLHWNKU4X9T2WSQFq10zXtvLjVjUcK6zeRMYJKA0X5pZf9biLFIUAkw5val/jU4D9TAYOOpDiPVJRduWin9OoWP3RSw9rKhCZXjZdrwEBjA+Syl/XV1WojlKLT8RYEDFC9/yrVyZWzhbwrJCpd4J+2dC6UId7th8ROvuCo6fUOzFk0HAHn84pgTMFiE479FKyEcp0BEtNNlTNWV3B2lji2OP2ROxmwd+lTuIqbaxRZ3OpkmfAs8RugygXyblhwahnCwkeOB+FhJ+s9iZRe1IEk9INjivi6T4FPPtT0jSquLgG+sv+TD/RwvjZhL/TqidL+1ne/V1EJC+l3ejqp7gb+GqW6GVsiukHiMyJFOdOT2yFLhNvqPlkSOp+0EKZn5e98nnCei7YhmimjPus4kggW4/bajX6Zu1POyLUq0AQSN2YNJ8T3tP20DCxEQXvJFw9UVRd17lvhi36ogE5qZkNKgepc00uT8BLK4d7/1Sr3uYzOO7VDu/JCI8WEiFvHSmhauw6PeVy3zIJy9QgJ+LvEteMGUhJ+2h6fpox80FHCqnw08Yr3DUIE7EthJUXpyTQBxHST7LsSYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jM1RjG70PAfC6v2uFar5iUihO+vAzYz2BYU0NqUX10QypqAgpPMrD8AhscF5?=
 =?us-ascii?Q?LnYc4LKj7oCgPD+dHEFm9nwuN3vPHBdfdOM0QTGel6GprWDfMxP3ua+Df2Mp?=
 =?us-ascii?Q?4c7HwpCwRiQZ/8EXH/M0HZ9mpRUKuiSdtWBQLzw2DyjtmY+06KoWT/qk/zKu?=
 =?us-ascii?Q?c+axW/KL44rHvrjDJtayVm3Vu1yz/6JXuJRJPWD4wSnkDpZVMjHtnHKLxvno?=
 =?us-ascii?Q?5M8ybfH2GXGiXZfFwmCcwGvmRPYw4JoEQbIKXLmrpowemAYXThkPRg/hsVQp?=
 =?us-ascii?Q?cpGi4UXpeM9lgqXp8dXNzPSHNDyBNKBv3/OS7UshSIvjD5U0rNUnGhmRG+Q2?=
 =?us-ascii?Q?xgRh2wGH+Ya152q9pc2POsFvfY82q9TsqHZWt2kkJyN2Ac/npDu6UUMJGCZ0?=
 =?us-ascii?Q?CLlGY1kkT0QwY64QL4zJ7YgTkv0ArFrAx26rx/cvKTzSc1/CvlziaBnGdD2+?=
 =?us-ascii?Q?VvBD81EN49Q/B6fQS0fnE4fb8LS152+hFwX6VTTKJB2HHru4FNw2hpDv4g1I?=
 =?us-ascii?Q?XsQ5fmSAdRi2mWp5m7mnhBTr8KhpfdbSeSGPureSvIeqI+ioUZmapdW9kEgg?=
 =?us-ascii?Q?MRYxWZqLaFgDR/n8MaxSZxxsgLJABQryzU/sBBMf/tdslCwEES1k6t7gYW+o?=
 =?us-ascii?Q?F8y5+9oyulIC2q7HnvwPyAJyvma29sEup9QoCHwDrS2sVgRLngNXkcC9Myhi?=
 =?us-ascii?Q?/l4UpI5r6VxQg8uAkYbYF2tf46vFFbhq4JH8XGGqpZDNrifyyV4G2+ur1C/u?=
 =?us-ascii?Q?4+QsIiJIw7tvFRlrWEIJf4iJnvInhQPz7vbzjzm/xriSfiT4GHf3uU7DCHkU?=
 =?us-ascii?Q?dwnV1agkjaf88dnZ2vJIPQaU9I4kmszqJ3D5xekRPmEk2xkIO0Y4fziIwJyw?=
 =?us-ascii?Q?dagi8ZFYRCc7uZdXVyWmKhceOIEMotPK9MTBWq/850BRyHx2QUL9ygv4TJE0?=
 =?us-ascii?Q?XK9s5ERNYZ5wr78WxN6jLk3rfigy5uVqbHTKvg5RaJGsgfJqYGtdmhvJf1Sd?=
 =?us-ascii?Q?ihy+FHiWvRYCI984V2f/dZHVEj82p4Kgur0ypsfGs5+os2DY6Ta7L2Czg1IT?=
 =?us-ascii?Q?NQUjdv7iD0WI3pg9HvYbm1RQlZpvYZwk5HeZjUVj2EWy5s5HxgR5bDMgIlGk?=
 =?us-ascii?Q?AP/hUpUWXJiFrl8Q4Or4gqLFMm6jKAOGK784HzADnFLQr9FjjqaivVF77IkM?=
 =?us-ascii?Q?pGF9x8/+QHlDvFoHFQxywWVDyzbDYE/T4MZVjGUPg4gjTA/JsFX61lghsHqO?=
 =?us-ascii?Q?B/9O0YozIBRKe+9lql3+7mAJgwJZnWYc6lfrD/xjuCeT67zKv+7kaQxuPffc?=
 =?us-ascii?Q?tQ1QNFRw7ZC2HfKq60B4CSu3MgSRIvXUNGR6j3KVTz2DLfgt5iYWaRXS7Ghc?=
 =?us-ascii?Q?QctzhOe+DOjoi1NK35PvaAajd2+9SwnL8bIg8Aj+cR1cYcxtuzNP1Kl7g6B8?=
 =?us-ascii?Q?LMQZGVYC6z88xy4jONqTVNf2RwsRPOs4Tl13+EOC1vyNxdkFWBHxAXE7JTYb?=
 =?us-ascii?Q?V6jeQwlx5Vk9XkdkMDHnDwkXFGNR7ZpT5JeL7vfDsdaYlfhaMXg/kXSJYW7n?=
 =?us-ascii?Q?JbJEITzDqX4burKd0zl0pRGsHIiJz+3n+o9trY26jSpTRPy3TCPnnNJ6XdJL?=
 =?us-ascii?Q?PSZ9nyGQ+P0dN5plNyeRheusxRNI/fC706CC3VKZjpmnuJFuwpYx+29XPvt1?=
 =?us-ascii?Q?RtCA8j41smEJOMDuP/+af6xqteMGd0TUXSGv/kzSGALc5bEzhxJ1LluBMIla?=
 =?us-ascii?Q?oAyB2rr8IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DxyFUAQuAaTDoPn14VQV7UJvvUc0YtRa56yVAdkbmr7hZXem+s2lRyaTqKv6lvrt7FIXdNXhgJ2e/NrzkzImkqwgI/xRSJeEjhE8kOAWgBWT0mQDxg28KjknHHspZhowl9Yb9z5Uq70BWhjmVBOXb1KdzNc+jsaL5pZqOg7nq1JJDvwo3jZR6SrNOBvJ+7BDzGfUWro0heoeA47YHhNzVKliIGOgU5XFwLkQF6NCQA6BECJkkRCsaVToQrRV8uuhq1qm9BJ8/JN+JOjXDVT2RXe0Lo6cF2lI7/4YwUXqBw7qswCnBXK3+C/oTJMdRSC4LJ7H29MLypvoVRskB/781Xbn8YdazqiXZc1s1sGCS/tKawZuJIPIP0RvqSqFrKp0pJikuq1dkGm+bVLm+ZPTPAwUlQ8iiIQk/eW/w7yg6TK3KdXYL+tJUNbrkCppb+e3AHqOELVnnBs82+pyIeORfvn7OEAMa4a7CfGPl0K30j+k1FxuQBu67vz7GGrfHngpffTaO5Ol57YwClz03YU+lzYWVvKWIK++p6vj9LHbdySBkQLjNMKQ60Ber1SjV+BbxrAPvCsQPcF8YcLdIBxTw4b4rtGIRxu9T8YPtqzKq/I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927dae6e-c530-4fd5-3144-08de784b7a7e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:04:30.7397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u2aBOT8mSLeQKNxyYZKh/FpsC/HgxhB6kp4ESnBOBOJwMcEOUvXZhuJc9WxuTAbQ3hyCwCeTVgJNipXiMeXSkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MCBTYWx0ZWRfX8Abg4SB0PdJh
 E7JNnevzT1xQf2vdYkYAzJMOIYSnV5gZbUr8yKa0yRfXByYsHGwJKCux2x2T26FZQT4alCiD2if
 GLQJYYqFdYqvvMp/apFNkp9WGa1VAOWQU9tATe7wKxwnTzhLESTAZdl1ObP6OpthPnnVk1m5JHd
 EuG7joPYL6PL/bLtqOOSsmBgxMpnPKuWWOLM3nGmXYfoYguyklp8sHOiUnMyvbpTq8s3pVKfjTd
 6LWtiXbtoa0cluhUxdCntkz/rcPPNH55vG5lCGXNa7Hn3OOOzLRWnVfAkRBUefy7WA4BZJKaesA
 3kjduuhapdLWa1rEIYAALuHv8iIQ3z0vTfdWsgxEDseYHlS6u2KRnfhkpcjURPv1y36EqVX/s6M
 m0xS0k9BrpmwSn6PrIPp83Xa3O1NMKJanDYoghOxkhJTZxskgsSCqq3ddRRvltlfAmH82jsdvZH
 tFgStVaKQJg1JYccqNQ==
X-Authority-Analysis: v=2.4 cv=Vcf6/Vp9 c=1 sm=1 tr=0 ts=69a56ec4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=2mGz-nUKjLqHj7hQOi4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: gKsK2z9MPMZ5MuxVZ4xsRIclLgz1-dKc
X-Proofpoint-GUID: gKsK2z9MPMZ5MuxVZ4xsRIclLgz1-dKc
X-Stat-Signature: kkesn79qzp4ea7ugpm11ccwnecfrq8d4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BC0840004
X-HE-Tag: 1772449480-798777
X-HE-Meta: U2FsdGVkX1+8pQIpZnij0QE9eNbasvzHM8tyRZk+9feADJ6f3yVnF3Fvlv5qFa8CJL0iQ06v4SbmnuY1ImxlfKdZQDnR1ewf52SuqTZ/csObP0tpI0xf2N0/MtS6fWzKPNKWYqhhggRFbXWlh/AnmhSICZvQAuxy9BvGTvqUYdmmgonwqP5oDCo0eeDkYBY2pFRuh3KCJM/e8X/tLp7R7ObwYYpAtdX+gA8ulqKGR8xnJq5uD6so4cHNGhd98RlGjNXwSIgZjONqF1L9LcGzazRCW6bbl73gYAsMmkV71Bat9AYy0xEYtXB62wh5VR115KgPseKZ5llVllOu8LTjafY8dhs9ZXBydHqlwrC7SShJBlY8a1qI011G9PRWAJYBcli8w3/uzODfG3x3GoBb4v5Sx34f7Er7WocbvXYryxb1+lBDy3qogPMnk6MxCINwtqP1zcN9DMngFXgXorW+G6IDnjtrwzUDl7CE5nfj8HQAfKyCFMOAoPa081/TvADVPW4DRGnrthWdX2H5md0YOxECpWabb48Qq8x2XEFopk2UahBBsCImxlQ60eD7bK/RTFwXsDNlZ14t+t5tioem4x6ZXjkh2sy5EfDdZKYhlTBycF8XGVm3KklUKsKTwBedv3PT6fBaM8Zny1I27kxIywiZLUDJvJtDCVPEsar2nE6lHTqQninohRQ+PkjUyqfhQqole+IE1Hvw+LpsR8uoy94PdYPy1SvsAdAn9A9Pd5TAfjsh5FV4F9q/guGmGbGaOFN4Dgfkh6k9uqhbP0U5XntW2CYwHuel/n/yDf+N71SyfhdAGjGSBRurtmrOs320KafRpMfRTuiNbp2CWl+WUzKH+QsWJIDeFcoXr9PuZMQkxhp2EOORruggXx2iB8tlZBk6zT6TWy0u6/oY4EZ1m5X8i5pfa1/ot4Fw9zLIc14OvS6g/B4Qjox1e7KEobWFtV3VznhbwpfEjDnq0g/
 ZmnWvN2y
 vSMBjGHOnZrzZBaL+pr3G95NT4sGDW71NkRsozVzq1Ubb0BFbGKkU+kKQ492aMcd0eD0XQpJo8yJocfqsskisBXIexUoRrV7YgdSFWCnWeE4XVcbIM36e//tpMob8XNp9M7DgUlsyrnVecC2ejzKV3BvZhir8jb0GP4+ogHOFTvN/S9/w1Y7w6HnntLbjVLMsk3BESypW9KgzpOzyWP+JlqzcfwHUtekE47thMj0LeHW0EBJ/O20ur0T9E6zI10XnXk//rFwu/yvAl5JeHPcZXDeDSoZFmVMXF6wAIOP0eCHH4RcohYwJK+jWD1n40qx1zgkoKjZTzPzbNjvV3kpbBdqgcOGw+A2R5wHdp51cS1fCFauqwxVh/00LQzPIBjWnvCVFGPK8+BOXx/xqglxHcLVoDYznsYhXw3Z9a/P+Aio+3RsfHp/chyjXr4UA5VlCV2r1de0KWwusje3SCbkQ5Vja5dwPcpKLNM0nZsA/xFVjMRQ5hOpOrYgyI50Iuuz2A/H0xXbt1DoyRdJB4262SRjpHatWyqYHwuI0lR0mMU9P2Zs+HRnzXMswUpwoI0AFOlxkShbmmo1yZbU8EJQNhDZVe8oxpzzf3ODe77bKTGiHQFBqW5vkHck/JMkFFLz1LQM4pTBXFABJ1xob7K2nbUyNir280ih8talo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 07:41:50PM +0900, Harry Yoo wrote:
> On Mon, Mar 02, 2026 at 11:13:46AM +0100, Vlastimil Babka (SUSE) wrote:
> > Promote Harry Yoo from reviewer to maintainer. Harry's been involved in
> > slab development for multiple years now and doing a great job.
> 
> It's been my pleasure to get involved with folks in the slab subsystem
> over the years, and I'm happy to continue to do so!

I'd also like to thank Vlastimil, who has given me kind and constructive
feedback ever since I first started contributing to the kernel, five
years ago.

Back in 2021, I was a curious computer science undergrad with little
experience in kernel development, who decided to do something fun in the
kernel and sent a few patches to the slab subsystem. The first few
interactions with Vlastimil, who was generous with his feedback,
motivated me to keep contributing to the kernel as a hobby.

Through the discussions and collaboration we've had, I feel I've grown
into a better engineer. I'm glad that this growth has allowed me to
give back to the community as a contributor and now as a maintainer.

And this is all thanks to you, Vlastimil ;)

-- 
Cheers,
Harry / Hyeonggon

